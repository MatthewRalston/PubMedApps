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

require 'spec_helper'
require 'nokogiri'

module PubMedApps
  describe EUtils do

    describe "::elink" do
      it "takes a PMID and returns an xml object describing the matches" do
        doc = EUtils.elink SpecConst::PMID
        expect(doc).to be_an_instance_of Nokogiri::XML::Document
      end

      it "raises an ArgumentError if not passed a proper PMID" do
        bad_pmid = 'fahehe'
        err_msg = "#{bad_pmid} is not a proper PMID"
        expect { EUtils.elink bad_pmid }.to raise_error(ArgumentError, err_msg)
      end
    end

    describe "::fetch" do
      it "returns EFetch info for given PMID" do
        doc = EUtils.fetch SpecConst::PMID
        expect(doc).to be_an_instance_of Nokogiri::XML::Document
      end

      it "can accept multiple pmids per query" do
        id1 = '23391036'
        id2 = '21143941'
        expect(EUtils.fetch(id1, id2).css('PubmedArticle').count).to eq 2
      end

      it "raises an ArgumentError if not passed a proper PMID" do
        id1 = '23391036'
        id2 = '21143941'
        bad_pmid = 'fahehe'
        err_msg = "#{bad_pmid} is not a proper PMID"
        expect {
          EUtils.fetch id1, bad_pmid, id2
        }.to raise_error(ArgumentError, err_msg)
      end
    end
  end
end
