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

require 'open-uri'

module PubMedApps

  # Provides methods for getting related pubmed citations.
  class Citation
    attr_accessor :pmid, :score, :abstract, :title, :pub_date, :references

    # @raise [ArgumentError] if passed improper PMID
    #
    # @raise [ArgumentError] if not passed a String
    def initialize(pmid)
      unless pmid.kind_of? String
        raise(ArgumentError,
              "PubMedApps::Citation.new requires a String")
      end

      pmid.strip!
      
      if pmid.match /^[0-9]+$/
        @pmid = pmid
      else
        err_msg = "#{pmid} is not a proper PMID"
        raise ArgumentError, err_msg
      end

      @score = 0
    end

    # Only fetch the related citations if they are needed.
    #
    # The first call to related_citations stores the array in the
    # instance variable, and all subsequent calls just return that
    # value.
    #
    # @return [Array<Citation>] an array of related Citations
    def related_citations
      @related_citations ||= fetch_related_citations
    end

    # Gets the title, abstract and pub_date from EUtils.
    #
    # To avoid the EUtils overhead, call this only for the very first
    # Citation given by the user. The info for the related PMIDs will
    # be propagated by the #related_citations method.
    #
    # @note This methods pings NCBI eutils once.
    def get_info
      begin
        efetch_doc = EUtils.efetch @pmid
        @title = EUtils.get_titles(efetch_doc).first
        @abstract = EUtils.get_abstracts(efetch_doc).first
        @pub_date = EUtils.get_pub_dates(efetch_doc).first
        @references = EUtils.get_references(efetch_doc)
      rescue OpenURI::HTTPError => e
        @pmid, @title, @abstract, @pub_date, @references, @score = nil
        @citations = nil
      end
    end
    
    private

    # citations is an array of Citaiton objects
    #
    # @todo Change array of objects in place?
    #
    # @param citations [Arrary<Citation>] An array of Citation objects
    #
    # @param scores [Array<String>] An array of strings with the
    #   scores
    def add_scores citations, scores
      citations.zip(scores).each do |citation, score|
        citation.score = score
      end
      citations
    end

    def add_titles citations, titles
      citations.zip(titles).each do |citation, title|
        citation.title = title
      end
      citations
    end

    def add_abstracts citations, abstracts
      citations.zip(abstracts).each do |citation, abstract|
        citation.abstract = abstract
      end
      citations
    end

    def add_pub_dates citations, pub_dates
      citations.zip(pub_dates).each do |citation, pub_date|
        citation.pub_date = pub_date
      end
      citations
    end

    # Returns an array of Citations related to the pmid attribute
    #
    # Only takes the PMIDs in the LinkSetDb that contians the LinkName
    #   with pubmed_pubmed
    #
    # @note This methods pings NCBI eutils twice.
    #
    # @todo instead of using .first, could this be done with xpath?
    #
    # @todo Clean up this method.
    #
    # @return [Array<Citation>] an array of Citations
    def fetch_related_citations
      # @pmid will be nil if get_info was called and the PMID didn't
      # have a matching UID in NCBI
      return [] if @pmid.nil?
      
      doc = EUtils.elink @pmid
      pm_pm = doc.css('LinkSetDb').first

      # should be nil if there are no related citations OR get_info
      # was NOT called and the PMID didn't have a matching UID in NCBI
      return [] if pm_pm.nil?
      
      name = pm_pm.at('LinkName').text
      
      unless  name == 'pubmed_pubmed'
        abort("ERROR: We got #{name}. Should've been pubmed_pubmed. " +
              "Possibly bad xml file.")
      end

      citations = pm_pm.css('Link Id').map do |elem|
        Citation.new elem.text
      end
      scores = pm_pm.css('Link Score').map { |elem| elem.text }

      unless citations.count == scores.count
        abort("ERROR: different number of Citations and scores when " +
              "scraping xml")
      end

      # add the info from the EFetch for each citation
      related_pmids = citations.map { |citation| citation.pmid }
      efetch_doc = EUtils.efetch *related_pmids
      titles = EUtils.get_titles efetch_doc
      abstracts = EUtils.get_abstracts efetch_doc
      pub_dates = EUtils.get_pub_dates efetch_doc

      citations = add_scores citations, scores
      citations = add_titles citations, titles
      citations = add_abstracts citations, abstracts
      add_pub_dates citations, pub_dates
    end
  end
end
