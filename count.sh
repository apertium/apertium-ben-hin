cat apertium-ben-hin.ben-hin.dix | grep '<e' | grep -v '<!--.*<e' | grep -v "i=yes" | wc -l
cat apertium-ben-hin.ben-hin.dix | grep '<e' | grep -v '<!--.*<e' | grep -v "i=yes" | grep -v '"np"' | wc -l
