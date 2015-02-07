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

require 'coveralls'
Coveralls.wear!

require 'pub_med_apps'
require 'nokogiri'

module SpecConstants

  FAKE_XML =
    Nokogiri::XML '<?xml version="1.0"?>
<!DOCTYPE eLinkResult PUBLIC "-//NLM//DTD eLinkResult, 23 November 2010//EN" "http://www.ncbi.nlm.nih.gov/entrez/query/DTD/eLink_101123.dtd">
<eLinkResult>

	<LinkSet>
		<DbFrom>pubmed</DbFrom>
		<IdList>
			<Id>25313075</Id>
		</IdList>
		<LinkSetDb>
			<DbTo>pubmed</DbTo>
			<LinkName>pubmed_pubmed</LinkName>
			
				<Link>
				<Id>23391036</Id>
				<Score>46386839</Score>
			</Link>
			
		</LinkSetDb>
		
		
		
		<LinkSetDb>
			<DbTo>pubmed</DbTo>
			<LinkName>pubmed_pubmed_combined</LinkName>
			
				<Link>
				<Id>23391036</Id>
				<Score>46386839</Score>
			</Link>
			
		</LinkSetDb>
		<LinkSetDb>
			<DbTo>pubmed</DbTo>
			<LinkName>pubmed_pubmed_five</LinkName>
			
				<Link>
				<Id>23391036</Id>
				<Score>46386839</Score>
			</Link>
			
		</LinkSetDb>
		
		<LinkSetDb>
			<DbTo>pubmed</DbTo>
			<LinkName>pubmed_pubmed_refs</LinkName>
			
				<Link>
				<Id>25002514</Id>
				<Score>25002514</Score>
			</Link>
				<Link>
				<Id>235528</Id>
				<Score>235528</Score>
			</Link>
			
		</LinkSetDb>
		<LinkSetDb>
			<DbTo>pubmed</DbTo>
			<LinkName>pubmed_pubmed_reviews</LinkName>
			
				<Link>
				<Id>24809024</Id>
				<Score>24464268</Score>
			</Link>
				<Link>
				<Id>20858168</Id>
				<Score>16953735</Score>
			</Link>
			
		</LinkSetDb>
		<LinkSetDb>
			<DbTo>pubmed</DbTo>
			<LinkName>pubmed_pubmed_reviews_five</LinkName>
			
				<Link>
				<Id>24809024</Id>
				<Score>24464268</Score>
			</Link>
			
		</LinkSetDb>
	</LinkSet>
</eLinkResult>
'

  def self.PMIDS
    PMIDS
  end

  def self.FAKE_XML
    FAKE_XML
  end
end

