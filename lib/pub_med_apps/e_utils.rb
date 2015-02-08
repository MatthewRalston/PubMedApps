# Copyright 2015 Ryan Moore
# Contact: moorer@udel.edu
#
# This file is part of PubMedApps.
#
# PubMedApps is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# PubMedApps is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with PubMedApps.  If not, see <http://www.gnu.org/licenses/>.

module PubMedApps
  class EUtils
    # Return Nokogiri::XML::Document with pmids related to given
    # PMID
    #
    # @todo Sleeps for one second to avoid NCBI eutils limits. Find a
    #   better way.
    #
    # @param pmid [String] the PMID of article to get related
    #   pmids
    # 
    # @return [Nokogiri::XML::Document] a Nokogiri::XML::Document with
    #   the related pmids to the given PMID
    def self.elink pmid
      unless pmid.match /[0-9]+/
        err_msg = "#{pmid} is not a proper PMID"
        raise ArgumentError, err_msg
      end

      sleep 1
      uri = "http://eutils.ncbi.nlm.nih.gov/entrez/eutils/elink.fcgi" +
        "?dbfrom=pubmed&db=pubmed&cmd=neighbor_score&id=#{pmid}"
      Nokogiri::XML(open(uri)) { |config| config.strict.nonet }
    end

    # Use EFetch to get author, abstract, etc for each PMID given
    #
    # @todo Sleeps for one second to avoid NCBI eutils limits. Find a
    #   better way.
    #
    # @param *pmids [String, ...] as many PMIDs as you like
    #
    # @return [Nokogiri::XML::Document] a Nokogiri::XML::Document with
    #   the info for given PMIDs
    def self.fetch *pmids
      pmids.each do |pmid|
        unless pmid.match /[0-9]+/
          err_msg = "#{pmid} is not a proper PMID"
          raise ArgumentError, err_msg
        end
      end

      sleep 1
      uri = "http://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi" +
        "?db=pubmed&retmode=xml&rettype=abstract&id=#{pmids.join(',')}"
      Nokogiri::XML(open(uri)) { |config| config.strict.nonet }
    end

    def get_pmids doc
      selector = 'PubmedArticle > MedlineCitation > PMID'
      doc.css(selector).map { |elem| elem.text }
    end

    def get_titles doc
      selector =
        'PubmedArticle > MedlineCitation > Article > ArticleTitle'
      doc.css(selector).map { |elem| elem.text }
    end

    def get_abstracts doc
      selector = 'PubmedArticle > MedlineCitation > Article > ' +
        'Abstract > AbstractText'
      doc.css(selector).map { |elem| elem.text }
    end

    def get_pub_dates
      selector =
        'PubmedArticle > MedlineCitation > Article PubDate > Year'
      doc.css(selector).map { |elem| elem.text }
    end

  end
end
