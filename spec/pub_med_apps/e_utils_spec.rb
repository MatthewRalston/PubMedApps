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

module PubMedApps
  describe EUtils do

    let(:pmid) { '25313075' }
    describe "#new" do
      it "returns a new EUtils object" do
        expect(EUtils.new).to be_a EUtils
      end
    end

    # describe "#related_citations" do
    #   it "takes a PMID and returns an xml object" do
    #     expect(EUtils.related_citations(pmid)).to be_an_instance_of Nokogiri::XML
    #   end
    # end
  end
end
