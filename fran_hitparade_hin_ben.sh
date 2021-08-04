# cat plain_big_corpus_file.txt | this_script > output_file
# e.g.:
# cat ../apertium-hin/texts/wiki_hin.txt | this_script > output_file
apertium-destxt | lt-proc -w ../apertium-hin/hin.automorf.bin | cg-proc -w ../apertium-hin/hin.rlx.bin | apertium-tagger -u 2 -g ../apertium-hin/hin.prob | apertium-pretransfer | sed 's/\$[^\^]*\^/$\n^/g' | lt-proc -b ../apertium-ben-hin/hin-ben.autobil.bin  | grep '/@' | sed 's/\(<[^>]\+><[^>]\+>\)\(<[^>]\+>\)*/\1/g' | sed 's/\(<adj>\|<vblex>\|<rel>\|<vbser>\)\(<[^>]\+>\)*/\1/g' | apertium-retxt | cut -f2- -d'^' | cut -f1 -d'$' | sed 's/.*/^&$/g' | sort -f | uniq -c | sort -gr | sed 's/\/@.*$//' | sed 's/^\( *[0-9]*\) \^/\1\t/' | sed 's/</\t</'
