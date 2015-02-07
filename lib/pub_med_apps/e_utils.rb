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
  class EUtils
    def self.related_citations pmid
      xml_doc = EUtils.elink pmid
      xml_doc.css('LinkSetDb Id').map { |elem| elem.text }.uniq
    end

    # Return Nokogiri::XML::Document with citations related to given
    # PMID
    #
    # @param pmid [String] the PMID of article to get related
    # citations
    # 
    # @return [Nokogiri::XML::Document] A Nokogiri::XML::Document with
    # the related citations to the given PMID
    def self.elink pmid
      unless pmid.match /[0-9]+/
        err_msg = "#{pmid} is not a proper PMID"
        raise ArgumentError, err_msg
      end
      uri = "http://eutils.ncbi.nlm.nih.gov/entrez/eutils/elink.fcgi" +
        "?dbfrom=pubmed&db=pubmed&cmd=neighbor_score&id=#{pmid}"
      Nokogiri::XML(open(uri)) { |config| config.strict.nonet }
    end
  end
end
