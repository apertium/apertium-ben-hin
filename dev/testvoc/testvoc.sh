#!/bin/bash

if ! [[ -e testvoc.conf ]]; then
    echo "Testvoc configuration file (testvoc.conf) not found."
    exit 1
fi

TRIMMED=true

while getopts "equt" opt; do
  case $opt in
    e)
      ENCLITICS=true  # If the -e flag is used, enclitics are skipped for faster processing
      ;;
    q)
      QUIET=true  # If the -q flag is used, no summary is generated
      ;;
    u)
      UNKNOWNS=true  # If the -u flag is used, unknown words are checked
      ;;
    t)
      TRIMMED=false  # If the -t flag is used, the source monodix is not trimmed
      ;;
  esac
done

IFS=","
modes=($(grep -m 1 "^PairModes=" testvoc.conf | cut -d = -f 2))
modenames=($(grep -m 1 "^PairModeNames=" testvoc.conf | cut -d = -f 2))
langs=($(grep -m 1 "^PairLangs=" testvoc.conf | cut -d = -f 2))
langnames=($(grep -m 1 "^PairLangNames=" testvoc.conf | cut -d = -f 2))
unset IFS

for i in "${!modes[@]}"; do
    printf "== %.45s\n" "${modenames[$i]} ============================================"
    sl="${modes[$i]:0:3}"

    if [[ $sl = "ben" ]]; then
        monodix="../../../apertium-ben/apertium-ben.ben.dix"
    else
        monodix="../../../apertium-hin/apertium-hin.hin.dix"
    fi

    if [[ $ENCLITICS = true ]] && [[ $TRIMMED = false ]]; then
        bash inconsistency.sh -et ${modes[$i]} $monodix > .testvoc
    elif [[ $ENCLITICS = true ]]; then
        bash inconsistency.sh -e ${modes[$i]} $monodix > .testvoc
    elif [[ $TRIMMED = false ]]; then
        bash inconsistency.sh -t ${modes[$i]} $monodix > .testvoc
    else
        bash inconsistency.sh ${modes[$i]} $monodix > .testvoc
    fi
    grep -vP '(?!\\)\/.*   --------->   [^#].*\\\/' .testvoc | grep -vP '^\^@.*   --------->   \\@.*' | grep -e ' #' -e '\\\/' > testvoc-errors.${modes[$i]}.txt

    if ! [[ $QUIET ]]; then
        bash inconsistency-summary.sh .testvoc ${modes[$i]}
    fi
    rm .testvoc
done

if [[ $UNKNOWNS ]]; then
    for i in "${!langs[@]}"; do
        printf "== %.45s\n" "${langnames[$i]} ============================================"
        pushd ../../ > /dev/null; bash dev/testvoc/bidix-unknowns.sh ${langs[$i]} | grep -v ":<:" | grep -v "REGEX" | grep -v "<prn><enc>" > dev/testvoc/testvoc-missing.${langs[$i]}.txt; popd > /dev/null;
        printf "%s\n" "Missing entries: $(cat testvoc-missing.${langs[$i]}.txt | wc -l)"
    done
fi

exit 0
