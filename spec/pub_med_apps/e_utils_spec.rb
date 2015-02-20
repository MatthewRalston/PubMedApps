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
      doc = EUtils.efetch(*SpecConst::PMIDS)
    end
    
    describe "::elink" do
      it "takes PMID and returns an xml object describing matches" do
        doc = EUtils.elink SpecConst::PMID
        expect(doc).to be_an_instance_of Nokogiri::XML::Document
      end

      it "raises an ArgumentError if not passed a proper PMID" do
        bad_pmid = 'fahehe'
        err_msg = "#{bad_pmid} is not a proper PMID"
        expect { EUtils.elink bad_pmid }.to raise_error(ArgumentError,
                                                        err_msg)
      end
    end

    describe "::fetch" do
      it "returns EFetch info for given PMID" do
        doc = EUtils.efetch SpecConst::PMID
        expect(doc).to be_an_instance_of Nokogiri::XML::Document
      end

      it "can accept multiple pmids per query" do
        id1 = '23391036'
        id2 = '21143941'
        the_count = EUtils.efetch(id1, id2).css('PubmedArticle').count
        expect(the_count).to eq 2
      end

      it "raises an ArgumentError if not passed a proper PMID" do
        id1 = '23391036'
        id2 = '21143941'
        bad_pmid = 'fahehe'
        err_msg = "#{bad_pmid} is not a proper PMID"
        expect {
          EUtils.efetch id1, bad_pmid, id2
        }.to raise_error(ArgumentError, err_msg)
      end
    end

    describe "::get_pmids" do
      it "gets pmids from the EUtils.efetch result" do
        pmids = SpecConst::PMIDS
        expect(EUtils.get_pmids efetch_doc).to eq pmids
      end
    end

    describe "::get_titles" do
      it "gets titles from the EUtils.efetch result" do
        titles = SpecConst::TITLES
        expect(EUtils.get_titles efetch_doc).to eq titles
      end
    end

    describe "::get_abstracts" do
      it "gets abstracts from the EUtils.efetch result" do
        abstracts = SpecConst::ABSTRACTS
        expect(EUtils.get_abstracts efetch_doc).to eq abstracts
      end
    end

    describe "::get_pub_dates" do
      it "gets pub_dates from the EUtils.efetch result" do
        pub_dates = SpecConst::PUB_DATES
        expect(EUtils.get_pub_dates efetch_doc).to eq pub_dates
      end
    end

    describe "::wait" do
      it "prevents too many EUtils requests" do
        id = '23391036'
        start_time = Time.now
        9.times do
          EUtils.elink id
        end
        end_time = Time.now
        expected_duration = 3
        expect(end_time - start_time).to be >= expected_duration
      end
    end
  end
end
