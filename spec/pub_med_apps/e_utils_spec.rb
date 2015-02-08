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

    let(:efetch_doc) do
      id1 = '17284678'
      id2 = '9997'
      doc = EUtils.fetch(id1, id2)
    end
    
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

    describe "::get_pmids" do
      it "gets pmids from the EUtils.fetch result" do
        pmids = %w[17284678 9997]
        expect(EUtils.get_pmids efetch_doc).to eq pmids
      end
    end

    describe "::get_titles" do
      it "gets titles from the EUtils.fetch result" do
        titles = [SpecConst::TITLE_1, SpecConst::TITLE_2]
        expect(EUtils.get_titles efetch_doc).to eq titles
      end
    end

    describe "::get_abstracts" do
      it "gets abstracts from the EUtils.fetch result" do
        abstracts = [SpecConst::ABSTRACT_1, SpecConst::ABSTRACT_2]
        expect(EUtils.get_abstracts efetch_doc).to eq abstracts
      end
    end

    describe "::get_pub_dates" do
      it "gets pub_dates from the EUtils.fetch result" do
        pub_dates = %w[2007 1976]
        expect(EUtils.get_pub_dates efetch_doc).to eq pub_dates
      end
    end
  end
end
