#!/bin/bash

#Copyright     2018   ZheJiang University (smz)

data=/E/kaldi/egs/data_deal

#. ./cmd.sh
#划分训练/测试集的比例
divide-train-test=6

#解压数据集(data_aishell和resource_aishell)
local/untar.sh $data data_aishell || exit 1;
local/untar.sh $data resource_aishell || exit 1;

#重新划分数据的训练开发测试集
local/divide_data.sh $divide-train-test $data/data_aishell/wav $data/data_aishell/wav/data || exit 1;

#准备词典
#local/prepare_dict.sh 