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
  

  PMID = '25313075'
  PMIDS = %w[17284678 15 23391036]
  SCORES = %w[46386839 36386839 26086339]

  TITLE_1 = "Sequencing and analysis of chromosome 1 of Eimeria tenella reveals a unique segmental organization."

  TITLE_2 = "Increase in acetyl CoA synthetase activity after phenobarbital treatment."

  TITLE_3 = "A bioinformatic analysis of ribonucleotide reductase genes in phage genomes and metagenomes."

  TITLES = [TITLE_1, TITLE_2, TITLE_3]
  
  ABSTRACT_1 = "Eimeria tenella is an intracellular protozoan parasite that infects the intestinal tracts of domestic fowl and causes coccidiosis, a serious and sometimes lethal enteritis. Eimeria falls in the same phylum (Apicomplexa) as several human and animal parasites such as Cryptosporidium, Toxoplasma, and the malaria parasite, Plasmodium. Here we report the sequencing and analysis of the first chromosome of E. tenella, a chromosome believed to carry loci associated with drug resistance and known to differ between virulent and attenuated strains of the parasite. The chromosome--which appears to be representative of the genome--is gene-dense and rich in simple-sequence repeats, many of which appear to give rise to repetitive amino acid tracts in the predicted proteins. Most striking is the segmentation of the chromosome into repeat-rich regions peppered with transposon-like elements and telomere-like repeats, alternating with repeat-free regions. Predicted genes differ in character between the two types of segment, and the repeat-rich regions appear to be associated with strain-to-strain variation."

  ABSTRACT_2 = ""

  ABSTRACT_3 = "Ribonucleotide reductase (RNR), the enzyme responsible for the formation of deoxyribonucleotides from ribonucleotides, is found in all domains of life and many viral genomes. RNRs are also amongst the most abundant genes identified in environmental metagenomes. This study focused on understanding the distribution, diversity, and evolution of RNRs in phages (viruses that infect bacteria). Hidden Markov Model profiles were used to analyze the proteins encoded by 685 completely sequenced double-stranded DNA phages and 22 environmental viral metagenomes to identify RNR homologs in cultured phages and uncultured viral communities, respectively. RNRs were identified in 128 phage genomes, nearly tripling the number of phages known to encode RNRs. Class I RNR was the most common RNR class observed in phages (70%), followed by class II (29%) and class III (28%). Twenty-eight percent of the phages contained genes belonging to multiple RNR classes. RNR class distribution varied according to phage type, isolation environment, and the host's ability to utilize oxygen. The majority of the phages containing RNRs are Myoviridae (65%), followed by Siphoviridae (30%) and Podoviridae (3%). The phylogeny and genomic organization of phage and host RNRs reveal several distinct evolutionary scenarios involving horizontal gene transfer, co-evolution, and differential selection pressure. Several putative split RNR genes interrupted by self-splicing introns or inteins were identified, providing further evidence for the role of frequent genetic exchange. Finally, viral metagenomic data indicate that RNRs are prevalent and highly dynamic in uncultured viral communities, necessitating future research to determine the environmental conditions under which RNRs provide a selective advantage. This comprehensive study describes the distribution, diversity, and evolution of RNRs in phage genomes and environmental viral metagenomes. The distinct distributions of specific RNR classes amongst phages, combined with the various evolutionary scenarios predicted from RNR phylogenies suggest multiple inheritance sources and different selective forces for RNRs in phages. This study significantly improves our understanding of phage RNRs, providing insight into the diversity and evolution of this important auxiliary metabolic gene as well as the evolution of phages in response to their bacterial hosts and environments."

  ABSTRACTS = [ABSTRACT_1, ABSTRACT_2, ABSTRACT_3]
  PUB_DATES = %w[2007 1975 2013]
  
end

