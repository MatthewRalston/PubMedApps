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
  describe Citation do

    let(:citation) { Citation.new SpecConst::PMIDS.first }
    let(:xml_doc) do
      dir = File.dirname(__FILE__)
      fname = 'test.xml'
      Nokogiri::XML open File.join(dir, '..', 'test_files', fname)
    end

    describe "#new" do
      it "raises an ArgumentError if not passed a PMID" do
        bad_pmid = '456fahehe123'
        err_msg = "#{bad_pmid} is not a proper PMID"
        expect { Citation.new bad_pmid }.to raise_error(ArgumentError,
                                                        err_msg)
      end
      
      it "raises an ArgumentError if not passed a string" do
        bad_pmid = 17284678
        err_msg = "PubMedApps::Citation.new requires a String"
        expect { Citation.new bad_pmid }.to raise_error(ArgumentError,
                                                        err_msg)
      end

      it "strips whitespace from sloppy user input" do
        bad_pmid = " \t  17284678 \n   \t"
        pmid = Citation.new(bad_pmid).pmid
        expect(pmid).to eq '17284678'
      end
    end

    context "after calling #get_info" do
      before :all do
        @citation = Citation.new SpecConst::PMIDS.first
        @citation.get_info
      end
      
      describe "#pmid" do
        it "returns the original pmid" do
          expect(@citation.pmid).to eq SpecConst::PMIDS.first
        end
      end

      describe "#abstract" do
        it "returns the original abstract" do
          expect(@citation.abstract).to eq SpecConst::ABSTRACTS.first
        end
      end      

      describe "#pub_date" do
        it "returns the original pub_date" do
          expect(@citation.pub_date).to eq SpecConst::PUB_DATES.first
        end
      end      

      describe "#score" do
        it "returns the original score" do
          expect(@citation.score).to eq 0
        end
      end      

      describe "#title" do
        it "returns the original title" do
          expect(@citation.title).to eq SpecConst::TITLES.first
        end
      end
    end
    
    describe "#related_citations" do
      before(:each) do
        allow(EUtils).to receive_messages :elink => xml_doc
      end
      
      it "returns an array with related citations" do
        pmids = citation.related_citations.map { |id| id.pmid }
        expect(pmids).to eq SpecConst::PMIDS
      end

      it "the array is filled with Citations" do
        all_citations = citation.related_citations.all? do |id|
          id.instance_of? Citation
        end
        expect(all_citations).to be true
      end

      it "adds the score to the related Citation objects" do
        scores = citation.related_citations.map { |id| id.score } 
        expect(scores).to eq SpecConst::SCORES
      end

      it "adds the title to the related Citation objects" do
        titles = citation.related_citations.map { |id| id.title } 
        expect(titles).to eq SpecConst::TITLES
      end

      it "adds the abstract to the related Citation objects" do
        abstracts = citation.related_citations.map { |id| id.abstract } 
        expect(abstracts).to eq SpecConst::ABSTRACTS
      end

      it "adds the pub_date to the related Citation objects" do
        pub_dates = citation.related_citations.map { |id| id.pub_date } 
        expect(pub_dates).to eq SpecConst::PUB_DATES
      end

      it "returns an empty array if there are no related citations" do
        skip("Need to figure out eutils XML format when no related " <<
             "Citations")
      end
    end
  end
end
