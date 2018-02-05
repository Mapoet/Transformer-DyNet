# aliases
TRANSFORMER_DYNET=/home/choang/da33/choang/works/Transformer-DyNet/build_gpu
WORKING_FOLDER=/home/choang/da33/choang/works/Transformer-DyNet

#run job (en->de)
$TRANSFORMER_DYNET/transformer-train --max-seq-len 80 --minibatch-size 1024 --treport 512 --dreport 200000 -t $WORKING_FOLDER/experiments/data/wmt17/corpus.tc.jbpe40K.en-de.capped -d $WORKING_FOLDER/experiments/data/wmt17/newstest2013.tc.jbpe40K.en-de.capped -p $WORKING_FOLDER/experiments/models/wmt17/params.en-de.transformer.h4_l4_u512_do010101010101_att1_ls01_pe2_ml80_ffrelu --config-file $WORKING_FOLDER/experiments/models/wmt17/model-ende-baseline-medium-dropout-labelsm-sinusoid.cfg -e 100 --lr-eta 0.1 --lr-patience 10 --patience 20 --lr-eta-decay 2 --encoder-emb-dropout-p 0.1 --encoder-sublayer-dropout-p 0.1 --decoder-emb-dropout-p 0.1 --decoder-sublayer-dropout-p 0.1 --attention-dropout-p 0.1 --ff-dropout-p 0.1 --ff-activation-type 1 --nlayers 4 --num-units 512 --num-heads 4 --use-label-smoothing --label-smoothing-weight 0.1 --position-encoding 2 &>$WORKING_FOLDER/experiments/models/wmt17/log.en-de.transformer.h4_l4_u512_do010101010101_att1_ls01_pe2_ml80_ffrelu &

#decode
# newstst2013
$TRANSFORMER_DYNET/transformer-decode --dynet-mem 7000 --max-seq-len 80 -t $WORKING_FOLDER/experiments/data/wmt17/corpus.tc.jbpe40K.en-de.capped --beam 5 --model-cfg $WORKING_FOLDER/experiments/models/wmt17/model-ende-baseline-medium-dropout-labelsm-sinusoid.cfg -T $WORKING_FOLDER/experiments/data/wmt17/newstest2013.tc.jbpe40K.en.capped | sed 's/<s> //g' | sed 's/ <\/s>//g' | sed 's/@@ //g' > $WORKING_FOLDER/experiments/models/wmt17/translation-beam5.newstst2013.en-de.transformer.h4_l4_u512_do010101010101_att1_ls01_pe2_ml80_ffrelu
/home/choang/da33/choang/tools/mosesdecoder.4.0/scripts/generic/multi-bleu.perl $WORKING_FOLDER/experiments/data/wmt17/newstest2013.tc.de < $WORKING_FOLDER/experiments/models/wmt17/translation-beam5.newstst2013.en-de.transformer.h4_l4_u512_do010101010101_att1_ls01_pe2_ml80_ffrelu &>$WORKING_FOLDER/experiments/models/wmt17/translation-beam5.newstst2013.en-de.transformer.h4_l4_u512_do010101010101_att1_ls01_pe2_ml80_ffrelu.score-BLEU
perl /home/choang/da33/choang/tools/mosesdecoder.4.0/scripts/recaser/detruecase.perl < $WORKING_FOLDER/experiments/data/wmt17/newstest2013.tc.de | perl /home/choang/da33/choang/tools/mosesdecoder.4.0/scripts/tokenizer/detokenizer.perl -l de > $WORKING_FOLDER/experiments/data/wmt17/newstest2013.de
perl /home/choang/da33/choang/tools/mosesdecoder.4.0/scripts/recaser/detruecase.perl < $WORKING_FOLDER/experiments/models/wmt17/translation-beam5.newstst2013.en-de.transformer.h4_l4_u512_do010101010101_att1_ls01_pe2_ml80_ffrelu | perl /home/choang/da33/choang/tools/mosesdecoder.4.0/scripts/tokenizer/detokenizer.perl -l de | /home/choang/da33/choang/tools/mosesdecoder.4.0/scripts/generic/multi-bleu.perl $WORKING_FOLDER/experiments/data/wmt17/newstest2013.de &>$WORKING_FOLDER/experiments/models/wmt17/translation-beam5.newstst2013.en-de.transformer.h4_l4_u512_do010101010101_att1_ls01_pe2_ml80_ffrelu_detruecased_detokenized.score-BLEU # detruecased and detokenized BLEU
# official-like eval
perl /home/choang/da33/choang/tools/mosesdecoder.4.0/scripts/recaser/detruecase.perl < $WORKING_FOLDER/experiments/models/wmt17/translation-beam5.newstst2013.en-de.transformer.h4_l4_u512_do010101010101_att1_ls01_pe2_ml80_ffrelu | /home/choang/da33/choang/tools/mosesdecoder.4.0/scripts/tokenizer/detokenizer.perl > $WORKING_FOLDER/experiments/models/wmt17/translation-beam5.newstst2013.en-de.transformer.h4_l4_u512_do010101010101_att1_ls01_pe2_ml80_ffrelu.detok
/home/choang/da33/choang/tools/mosesdecoder.4.0/scripts/ems/support/wrap-xml.perl de $WORKING_FOLDER/experiments/data/wmt17/dev/newstest2013-ende-src.en.sgm < $WORKING_FOLDER/experiments/models/wmt17/translation-beam5.newstst2013.en-de.transformer.h4_l4_u512_do010101010101_att1_ls01_pe2_ml80_ffrelu.detok > $WORKING_FOLDER/experiments/models/wmt17/translation-beam5.newstst2013.en-de.transformer.h4_l4_u512_do010101010101_att1_ls01_pe2_ml80_ffrelu.detok.sgm
/home/choang/da33/choang/tools/mosesdecoder.4.0/scripts/generic/mteval-v13a.pl -c -s $WORKING_FOLDER/experiments/data/wmt17/dev/newstest2013-ende-src.en.sgm -r $WORKING_FOLDER/experiments/data/wmt17/dev/newstest2013-ende-ref.de.sgm -t $WORKING_FOLDER/experiments/models/wmt17/translation-beam5.newstst2013.en-de.transformer.h4_l4_u512_do010101010101_att1_ls01_pe2_ml80_ffrelu.detok.sgm
# newstst2014
$TRANSFORMER_DYNET/transformer-decode --dynet-mem 7000 --max-seq-len 80 -t $WORKING_FOLDER/experiments/data/wmt17/corpus.tc.jbpe40K.en-de.capped --beam 5 --model-cfg $WORKING_FOLDER/experiments/models/wmt17/model-ende-baseline-medium-dropout-labelsm-sinusoid.cfg -T $WORKING_FOLDER/experiments/data/wmt17/newstest2014.tc.jbpe40K.en.capped | sed 's/<s> //g' | sed 's/ <\/s>//g' | sed 's/@@ //g' > $WORKING_FOLDER/experiments/models/wmt17/translation-beam5.newstst2014.en-de.transformer.h4_l4_u512_do010101010101_att1_ls01_pe2_ml80_ffrelu
/home/choang/da33/choang/tools/mosesdecoder.4.0/scripts/generic/multi-bleu.perl $WORKING_FOLDER/experiments/data/wmt17/newstest2014.tc.de < $WORKING_FOLDER/experiments/models/wmt17/translation-beam5.newstst2014.en-de.transformer.h4_l4_u512_do010101010101_att1_ls01_pe2_ml80_ffrelu &>$WORKING_FOLDER/experiments/models/wmt17/translation-beam5.newstst2014.en-de.transformer.h4_l4_u512_do010101010101_att1_ls01_pe2_ml80_ffrelu.score-BLEU
perl /home/choang/da33/choang/tools/mosesdecoder.4.0/scripts/recaser/detruecase.perl < $WORKING_FOLDER/experiments/data/wmt17/newstest2014.tc.de | perl /home/choang/da33/choang/tools/mosesdecoder.4.0/scripts/tokenizer/detokenizer.perl -l de > $WORKING_FOLDER/experiments/data/wmt17/newstest2014.de
perl /home/choang/da33/choang/tools/mosesdecoder.4.0/scripts/recaser/detruecase.perl < $WORKING_FOLDER/experiments/models/wmt17/translation-beam5.newstst2014.en-de.transformer.h4_l4_u512_do010101010101_att1_ls01_pe2_ml80_ffrelu | perl /home/choang/da33/choang/tools/mosesdecoder.4.0/scripts/tokenizer/detokenizer.perl -l de | /home/choang/da33/choang/tools/mosesdecoder.4.0/scripts/generic/multi-bleu.perl $WORKING_FOLDER/experiments/data/wmt17/newstest2014.de &>$WORKING_FOLDER/experiments/models/wmt17/translation-beam5.newstst2014.en-de.transformer.h4_l4_u512_do010101010101_att1_ls01_pe2_ml80_ffrelu_detruecased_detokenized.score-BLEU # detruecased and detokenized BLEU
# official-like eval
perl /home/choang/da33/choang/tools/mosesdecoder.4.0/scripts/recaser/detruecase.perl < $WORKING_FOLDER/experiments/models/wmt17/translation-beam5.newstst2014.en-de.transformer.h4_l4_u512_do010101010101_att1_ls01_pe2_ml80_ffrelu | /home/choang/da33/choang/tools/mosesdecoder.4.0/scripts/tokenizer/detokenizer.perl -l de > $WORKING_FOLDER/experiments/models/wmt17/translation-beam5.newstst2014.en-de.transformer.h4_l4_u512_do010101010101_att1_ls01_pe2_ml80_ffrelu.detok
/home/choang/da33/choang/tools/mosesdecoder.4.0/scripts/ems/support/wrap-xml.perl de $WORKING_FOLDER/experiments/data/wmt17/dev/newstest2014-deen-src.en.sgm < $WORKING_FOLDER/experiments/models/wmt17/translation-beam5.newstst2014.en-de.transformer.h4_l4_u512_do010101010101_att1_ls01_pe2_ml80_ffrelu.detok > $WORKING_FOLDER/experiments/models/wmt17/translation-beam5.newstst2014.en-de.transformer.h4_l4_u512_do010101010101_att1_ls01_pe2_ml80_ffrelu.detok.sgm
/home/choang/da33/choang/tools/mosesdecoder.4.0/scripts/generic/mteval-v13a.pl -c -s $WORKING_FOLDER/experiments/data/wmt17/dev/newstest2014-deen-src.en.sgm -r $WORKING_FOLDER/experiments/data/wmt17/dev/newstest2014-deen-ref.de.sgm -t $WORKING_FOLDER/experiments/models/wmt17/translation-beam5.newstst2014.en-de.transformer.h4_l4_u512_do010101010101_att1_ls01_pe2_ml80_ffrelu.detok.sgm
# newstst2015
$TRANSFORMER_DYNET/transformer-decode --dynet-mem 7000 --max-seq-len 80 -t $WORKING_FOLDER/experiments/data/wmt17/corpus.tc.jbpe40K.en-de.capped --beam 5 --model-cfg $WORKING_FOLDER/experiments/models/wmt17/model-ende-baseline-medium-dropout-labelsm-sinusoid.cfg -T $WORKING_FOLDER/experiments/data/wmt17/newstest2015.tc.jbpe40K.en.capped | sed 's/<s> //g' | sed 's/ <\/s>//g' | sed 's/@@ //g' > $WORKING_FOLDER/experiments/models/wmt17/translation-beam5.newstst2015.en-de.transformer.h4_l4_u512_do010101010101_att1_ls01_pe2_ml80_ffrelu
/home/choang/da33/choang/tools/mosesdecoder.4.0/scripts/generic/multi-bleu.perl $WORKING_FOLDER/experiments/data/wmt17/newstest2015.tc.de < $WORKING_FOLDER/experiments/models/wmt17/translation-beam5.newstst2015.en-de.transformer.h4_l4_u512_do010101010101_att1_ls01_pe2_ml80_ffrelu &>$WORKING_FOLDER/experiments/models/wmt17/translation-beam5.newstst2015.en-de.transformer.h4_l4_u512_do010101010101_att1_ls01_pe2_ml80_ffrelu.score-BLEU
perl /home/choang/da33/choang/tools/mosesdecoder.4.0/scripts/recaser/detruecase.perl < $WORKING_FOLDER/experiments/data/wmt17/newstest2015.tc.de | perl /home/choang/da33/choang/tools/mosesdecoder.4.0/scripts/tokenizer/detokenizer.perl -l de > $WORKING_FOLDER/experiments/data/wmt17/newstest2015.de
perl /home/choang/da33/choang/tools/mosesdecoder.4.0/scripts/recaser/detruecase.perl < $WORKING_FOLDER/experiments/models/wmt17/translation-beam5.newstst2015.en-de.transformer.h4_l4_u512_do010101010101_att1_ls01_pe2_ml80_ffrelu | perl /home/choang/da33/choang/tools/mosesdecoder.4.0/scripts/tokenizer/detokenizer.perl -l de | /home/choang/da33/choang/tools/mosesdecoder.4.0/scripts/generic/multi-bleu.perl $WORKING_FOLDER/experiments/data/wmt17/newstest2015.de &>$WORKING_FOLDER/experiments/models/wmt17/translation-beam5.newstst2015.en-de.transformer.h4_l4_u512_do010101010101_att1_ls01_pe2_ml80_ffrelu_detruecased_detokenized.score-BLEU # detruecased and detokenized BLEU
# newstst2017
$TRANSFORMER_DYNET/transformer-decode --dynet-mem 9000 --max-seq-len 80 -t $WORKING_FOLDER/experiments/data/wmt17/corpus.tc.jbpe40K.en-de.capped --beam 5 --model-cfg $WORKING_FOLDER/experiments/models/wmt17/model-ende-baseline-medium-dropout-labelsm-sinusoid.cfg -T $WORKING_FOLDER/experiments/data/wmt17/newstest2017.tc.jbpe40K.en.capped | sed 's/<s> //g' | sed 's/ <\/s>//g' | sed 's/@@ //g' > $WORKING_FOLDER/experiments/models/wmt17/translation-beam5.newstst2017.en-de.transformer.h4_l4_u512_do010101010101_att1_ls01_pe2_ml80_ffrelu
/home/choang/da33/choang/tools/mosesdecoder.4.0/scripts/generic/multi-bleu.perl $WORKING_FOLDER/experiments/data/wmt17/newstest2017.tc.de < $WORKING_FOLDER/experiments/models/wmt17/translation-beam5.newstst2017.en-de.transformer.h4_l4_u512_do010101010101_att1_ls01_pe2_ml80_ffrelu &>$WORKING_FOLDER/experiments/models/wmt17/translation-beam5.newstst2017.en-de.transformer.h4_l4_u512_do010101010101_att1_ls01_pe2_ml80_ffrelu.score-BLEU
perl /home/choang/da33/choang/tools/mosesdecoder.4.0/scripts/recaser/detruecase.perl < $WORKING_FOLDER/experiments/data/wmt17/newstest2017.tc.de | perl /home/choang/da33/choang/tools/mosesdecoder.4.0/scripts/tokenizer/detokenizer.perl -l de > $WORKING_FOLDER/experiments/data/wmt17/newstest2017.de
perl /home/choang/da33/choang/tools/mosesdecoder.4.0/scripts/recaser/detruecase.perl < $WORKING_FOLDER/experiments/models/wmt17/translation-beam5.newstst2017.en-de.transformer.h4_l4_u512_do010101010101_att1_ls01_pe2_ml80_ffrelu | perl /home/choang/da33/choang/tools/mosesdecoder.4.0/scripts/tokenizer/detokenizer.perl -l de | /home/choang/da33/choang/tools/mosesdecoder.4.0/scripts/generic/multi-bleu.perl $WORKING_FOLDER/experiments/data/wmt17/newstest2017.de &>$WORKING_FOLDER/experiments/models/wmt17/translation-beam5.newstst2017.en-de.transformer.h4_l4_u512_do010101010101_att1_ls01_pe2_ml80_ffrelu_detruecased_detokenized.score-BLEU # detruecased and detokenized BLEU
