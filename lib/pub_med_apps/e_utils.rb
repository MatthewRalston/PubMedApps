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
  # Provides methods for interfacing with NCBI's EUtils service
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

    # Get PMIDs of queres from the EFetch Nokogiri::XML::Document
    #
    # @param doc [Nokogiri::XML::Document] a doc with the results from
    #   the EFetch call
    #
    # @return [Array<String>] an array of PMID strings
    def self.get_pmids doc
      selector = 'PubmedArticle > MedlineCitation > PMID'
      doc.css(selector).map { |elem| elem.text }
    end

    # Get titles of queres from the EFetch Nokogiri::XML::Document
    #
    # @param doc [Nokogiri::XML::Document] a doc with the results from
    #   the EFetch call
    #
    # @return [Array<String>] an array of title strings
    def self.get_titles doc
      selector =
        'PubmedArticle > MedlineCitation > Article > ArticleTitle'
      doc.css(selector).map { |elem| elem.text }
    end

    # Get abstracts of queres from the EFetch Nokogiri::XML::Document
    #
    # @todo If an article doesn't have an abstract, returns "" for that
    #   article. If an article has a compound abstract, eg Intro,
    #   Methods, Results, ..., it collapses that into a single
    #   paragraph.
    #
    # @param doc [Nokogiri::XML::Document] a doc with the results from
    #   the EFetch call
    #
    # @return [Array<String>] an array of abstract strings
    def self.get_abstracts doc
      articles = doc.css('PubmedArticle > MedlineCitation > Article') 
      articles.each_with_object(Array.new) do |article, abstracts|
        abstract = article.css('Abstract > AbstractText').children
        if abstract.count == 0 # article has no abstract
          abstracts << ""
        elsif abstract.count > 1 # article has compound abstrct
          abstracts << abstract.map { |elem| elem.text }.join(' ')
        else # article has simple abstract
          abstracts << abstract.text
        end
      end
    end

      # Get pub dates of queres from the EFetch Nokogiri::XML::Document
      #
      # @param doc [Nokogiri::XML::Document] a doc with the results from
      #   the EFetch call
      #
      # @return [Array<String>] an array of pub date strings
      def self.get_pub_dates doc
        selector =
          'PubmedArticle > MedlineCitation > Article PubDate > Year'
        doc.css(selector).map { |elem| elem.text }
      end
    end
  end
