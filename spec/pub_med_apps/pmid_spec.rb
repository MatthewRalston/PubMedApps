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
  describe Pmid do

    let(:pmid) { Pmid.new(SpecConst::PMID) }
    let(:xml_doc) do
      dir = File.dirname(__FILE__)
      fname = 'test.xml'
      Nokogiri:: XML open File.join(dir, '..', 'test_files', fname)
    end

    describe "#new" do
      it "raises an ArgumentError if not passed a PMID" do
        bad_pmid = 'fahehe'
        err_msg = "#{bad_pmid} is not a proper PMID"
        expect { Pmid.new bad_pmid }.to raise_error(ArgumentError, err_msg)
      end
      
      it "raises an ArgumentError if not passed a string" do
        bad_pmid = 17284678
        err_msg = "PubMedApps::Pmid.new requires a String"
        expect { Pmid.new bad_pmid }.to raise_error(ArgumentError, err_msg)
      end
    end
    
    describe "#pmid" do
      it "returns the original pmid" do
        expect(pmid.pmid).to eq SpecConst::PMID
      end
    end

    describe "#related_pmids" do
      before(:each) do
        allow(EUtils).to receive_messages :elink => xml_doc
      end
      
      it "returns an array with related pmids" do
        expect(pmid.related_pmids.map { |id| id.pmid } ).to eq SpecConst::PMIDS
      end

      it "the array is filled with Pmids" do
        expect(pmid.related_pmids.all? { |id| id.instance_of? Pmid }).to be true
      end

      it "adds the score to the related Pmid objects" do
        expect(pmid.related_pmids.map { |id| id.score } ).to eq SpecConst::SCORES
      end

      it "adds the title to the related Pmid objects" do
        expect(pmid.related_pmids.map { |id| id.title } ).to eq SpecConst::TITLES
      end

      it "adds the abstract to the related Pmid objects" do
        expect(pmid.related_pmids.map { |id| id.abstract } ).to eq SpecConst::ABSTRACTS
      end

      it "adds the pub_date to the related Pmid objects" do
        expect(pmid.related_pmids.map { |id| id.pub_date } ).to eq SpecConst::PUB_DATES
      end
    end
  end
end
