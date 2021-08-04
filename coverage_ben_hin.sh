cat ../apertium-ben/Texts/sample_ben.txt | apertium-destxt | nice -n 19 lt-proc -w ben-hin.automorf.bin | apertium-retxt | sed 's/\$\W*\^/$\n^/g' > /tmp/ben-hin.coverage.txt

TOTAL=`cat /tmp/ben-hin.coverage.txt | wc -l`;
KNOWN=`cat /tmp/ben-hin.coverage.txt | grep -v '\*' | wc -l`;
COVER=`calc $KNOWN / $TOTAL`;

echo "ben-hin: $COVER"