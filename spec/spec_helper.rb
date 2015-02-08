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

module SpecConst
  attr_accessor :PMID, :PMIDS, :SCORES

  PMID = '25313075'
  PMIDS = %w[23391036 15]
  SCORES = %w[46386839 46086339]

  TITLE_1 = "Sequencing and analysis of chromosome 1 of Eimeria tenella reveals a unique segmental organization."

  TITLE_2 = "Magnetic studies of Chromatium flavocytochrome C552. A mechanism for heme-flavin interaction."
  
  ABSTRACT_1 = "Eimeria tenella is an intracellular protozoan parasite that infects the intestinal tracts of domestic fowl and causes coccidiosis, a serious and sometimes lethal enteritis. Eimeria falls in the same phylum (Apicomplexa) as several human and animal parasites such as Cryptosporidium, Toxoplasma, and the malaria parasite, Plasmodium. Here we report the sequencing and analysis of the first chromosome of E. tenella, a chromosome believed to carry loci associated with drug resistance and known to differ between virulent and attenuated strains of the parasite. The chromosome--which appears to be representative of the genome--is gene-dense and rich in simple-sequence repeats, many of which appear to give rise to repetitive amino acid tracts in the predicted proteins. Most striking is the segmentation of the chromosome into repeat-rich regions peppered with transposon-like elements and telomere-like repeats, alternating with repeat-free regions. Predicted genes differ in character between the two types of segment, and the repeat-rich regions appear to be associated with strain-to-strain variation."

  ABSTRACT_2 = "Electron paramagnetic resonance and magnetic susceptibility studies of Chromatium flavocytochrome C552 and its diheme flavin-free subunit at temperatures below 45 degrees K are reported. The results show that in the intact protein and the subunit the two low-spin (S = 1/2) heme irons are distinguishable, giving rise to separate EPR signals. In the intact protein only, one of the heme irons exists in two different low spin environments in the pH range 5.5 to 10.5, while the other remains in a constant environment. Factors influencing the variable heme iron environment also influence flavin reactivity, indicating the existence of a mechanism for heme-flavin interaction."
  
end

