make && cat ../apertium-hin/texts/hin_small.txt | apertium -d . hin-ben > new_transl_hin_ben.txt
diff cur_transl_hin_ben.txt new_transl_hin_ben.txt | more
