cat ../apertium-hin/texts/wiki_hin.txt | apertium-destxt | nice -n 19 lt-proc -w hin-ben.automorf.bin | apertium-retxt | sed 's/\$\W*\^/$\n^/g' > /tmp/hin-ben.coverage.txt

TOTAL=`cat /tmp/hin-ben.coverage.txt | wc -l`;
KNOWN=`cat /tmp/hin-ben.coverage.txt | grep -v '\*' | wc -l`;
COVER=`calc $KNOWN / $TOTAL`;

echo "hin-ben: $COVER"
