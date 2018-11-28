#!/bin/bash

#从源文件目录下复制数据到kaldi目录下 全部整理到data目录下
#data=/home1/shenmingzhang/kaldi/egs/aishell/compdata
#source=/home1/course2/ASR/data/data_aishell2/wav
data_dir=$1  #data_dir=$source
data=$2     #data=$data/wav/data

if [ ! -d $data ]; then
    mkdir $data
else
	echo "$0: $data目录已经存在"
	exit 0;
fi

echo "$0: 现在开始复制数据到data目录下"

for x in train dev test ; do
	cp -r $data_dir/$x/* $data
done

echo "$0: data目录已经准备完成"

exit 0;