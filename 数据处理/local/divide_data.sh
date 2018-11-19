#!/bin/bash


#重新划分数据集，将数据整合进data目录下后
#按train-test中的比例进行划分
#train-test中存储训练集和测试集的比例
train-test=$1
data_dir=$2  #存放train/test/dev的目录
data=$3
#生成wav/data目录
mkdir -p $data

for x in {train,test,dev}; do
	cd $data_dir/$x
	for y in ./* ;do
		cp $data_dir/$x/$y $data_dir/$data
    done
 done
