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
    BASE_URL = "http://eutils.ncbi.nlm.nih.gov/entrez/eutils"

    # @note NCBI requires email and app name from those using the
    #   EUtilities service
    APP_INFO = "email=moorer@udel.edu&tool=PubMedApps"
    
    # @todo NCBI says 3 request per second, but when i make it 0.33,
    #   my ::wait spec fails
    WAIT_TIME = 0.365

    # To avoid slow EFetch posts as well as avoid the URI too long
    # error that occurs somewhere around 900 PMIDs
    MAX_PMIDS = 100

    # A mutex for locking
    @@lock ||= Mutex.new

    @@last_fetch_time = nil
    
    # Return Nokogiri::XML::Document with pmids related to given
    # PMID
    #
    # @param pmid [String] the PMID of article to get related
    #   pmids
    #
    # @raise [ArgumentError] if passed an improper PMID
    # 
    # @return [Nokogiri::XML::Document] a Nokogiri::XML::Document with
    #   the related pmids to the given PMID
    def self.elink pmid
      unless pmid.match /[0-9]+/
        err_msg = "#{pmid} is not a proper PMID"
        raise ArgumentError, err_msg
      end

      EUtils.wait
      uri = "#{BASE_URL}/elink.fcgi?#{APP_INFO}" <<
        "&dbfrom=pubmed&db=pubmed&cmd=neighbor_score&id=#{pmid}"
      Nokogiri::XML(open(uri)) { |config| config.strict.nonet }
    end

    # Use EFetch to get author, abstract, etc for each PMID given.
    #
    # If there are > 100 PMIDs in your request, the method will only
    # take the first 100 PMIDs.
    #
    # @note From some of my testing it appears that if you EFetch >=
    #   900 PMIds, EUtils will not accept that URI. However, this
    #   could vary depending on the actual length of the URI and not
    #   simply the number of PMIDs that are posted.
    #
    # @todo Consider using WebEnv for large efetch requests.
    #
    # @note This methods pings NCBI eutils once.
    #
    # @param *pmids [String, ...] as many PMIDs as you like
    #
    # @raise [ArgumentError] if passed an improper PMID
    #
    # @return [Nokogiri::XML::Document] a Nokogiri::XML::Document with
    #   the info for given PMIDs
    def self.efetch *pmids
      pmids = pmids.take MAX_PMIDS
      pmids.each do |pmid|
        unless pmid.match /[0-9]+/
          err_msg = "#{pmid} is not a proper PMID"
          raise ArgumentError, err_msg
        end
      end

      EUtils.wait
      uri = "#{BASE_URL}/efetch.fcgi?#{APP_INFO}" <<
        "&db=pubmed&retmode=xml&rettype=abstract&id=#{pmids.join(',')}"
      Nokogiri::XML(open(uri)) { |config| config.strict.nonet }
    end

    # Get PMIDs of queres from the EFetch Nokogiri::XML::Document
    #
    # @note This methods pings NCBI eutils once.
    #
    # @param doc [Nokogiri::XML::Document] a doc with the results from
    #   the EFetch call
    #
    # @return [Array<String>] an array of PMID strings
    def EUtils.get_pmids doc
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
    # If an article doesn't have an abstract, returns "" for that
    # article. If an article has a compound abstract, eg Intro,
    # Methods, Results, ..., it collapses that into a single
    # paragraph.
    #
    # @todo Keep the compound abstract breakdown instead of collapsing
    #   it into a single paragraph.
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

    # Waits the alloted time set by NCBI if necessary.
    #
    # Similar to the BioRuby ncbi_access_wait method.
    #
    # @todo Since EUtils is never instantiated, if the code won't be
    #   threaded, do I need the Mutex?
    def self.wait
      @@lock.synchronize do
        if @@last_fetch_time
          time_since_last_fetch = Time.now - @@last_fetch_time
          if time_since_last_fetch < WAIT_TIME
            sleep WAIT_TIME - time_since_last_fetch
          end
        end
        @@last_fetch_time = Time.now
      end
    end
  end
end
