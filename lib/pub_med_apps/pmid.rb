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
  class Pmid
    attr_accessor :pmid, :score, :abstract, :title, :pub_date

    def initialize(pmid)
      if pmid.match /[0-9]+/
        @pmid = pmid
      else
        err_msg = "#{pmid} is not a proper PMID"
        raise ArgumentError, err_msg
      end

      @score = 0
    end

    # Only fetch the related pmids if they are needed.
    #
    # The first call to related_pmids stores the array in the instance
    # variable, and all subsequent calls just return that value.
    #
    # @return [Array<Pmid>] an array of related PMIDs
    def related_pmids
      @related_pmids ||= fetch_related_pmids
    end


    private

    def add_scores pmids, scores
      pmids.zip(scores).each do |pmid, score|
        pmid.score = score
      end
      pmids
    end

    def add_titles pmids, titles
      pmids.zip(titles).each do |pmid, title|
        pmid.title = title
      end
      pmids
    end

    def add_abstracts pmids, abstracts
      pmids.zip(abstracts).each do |pmid, abstract|
        pmid.abstract = abstract
      end
      pmids
    end

    def add_pub_dates pmids, pub_dates
      pmids.zip(pub_dates).each do |pmid, pub_date|
        pmid.pub_date = pub_date
      end
      pmids
    end

    # Returns an array of PMIDs related to the pmid attribute
    #
    # Only takes the PMIDs in the LinkSetDb that contians the LinkName
    #   with pubmed_pubmed
    #
    # @todo instead of using .first, could this be done with xpath?
    #
    # @return [Array<Pmid>] an array of string PMIDs
    def fetch_related_pmids
      doc = EUtils.elink @pmid
      pm_pm = doc.css('LinkSetDb').first
      name = pm_pm.at('LinkName').text
      
      unless  name == 'pubmed_pubmed'
        abort("ERROR: We got #{name}. Should've been pubmed_pubmed. " +
              "Possibly bad xml file.")
      end

      pmids = pm_pm.css('Link Id').map { |elem| Pmid.new elem.text }
      scores = pm_pm.css('Link Score').map { |elem| elem.text }

      unless pmids.count == scores.count
        abort("ERROR: different number of PMIDs and scores when " +
              "scraping xml")
      end

      # add the info from the EFetch for each pmid
      efetch_doc = EUtils.fetch *pmids.map { |pmid| pmid.pmid }
      titles = EUtils.get_titles efetch_doc
      abstracts = EUtils.get_abstracts efetch_doc
      pub_dates = EUtils.get_pub_dates efetch_doc

      pmids = add_scores pmids, scores
      pmids = add_titles pmids, titles
      pmids = add_abstracts pmids, abstracts
      add_pub_dates pmids, pub_dates
    end
  end
end
