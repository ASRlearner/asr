#!/bin/bash

#Copyright     2018   ZheJiang University (smz)

data=/home1/shenmingzhang/kaldi/egs/aishell/compdata
source=/home1/course2/ASR/data/data_aishell2/wav

#. ./cmd.sh
#划分训练/测试集的比例 默认为6：1：1
#参数加-符号不识别
divide=6

#解压数据集(data_aishell和resource_aishell)
#local/untar.sh $data data_aishell || exit 1;
#local/untar.sh $data resource_aishell || exit 1;

local/copy.sh $source $data/wav/data || exit 1;

#重新划分数据的训练开发测试集
#local/divide_data.sh $divide $data/wav $data/wav/data || exit 1;

#准备词典
#local/prepare_dict.sh $data/resource || exit 1;

#正式的数据准备部分
#local/prepare_data.sh $data/wav $data/transcript || exit 1;

