#!/bin/bash


#重新划分数据集，将数据整合进data目录下后
#按train-test中的比例进行划分
#train-test中存储训练集和测试集的比例
ratio=$1
data_dir=$2  #存放train/test/dev的目录
data=$3     #生成wav/data目录

mkdir -p $data

for x in train test dev; do
	#把三大目录下的文件转移到wav/data目录下并删除原目录和目录下所有文件
	cp -r $data_dir/$x/* $data
	rm -rf $data_dir/$x/*
done

echo "$0: 数据已经全部转移到 $data 目录下！"

if [ ! -d $data_dir/train ] ; then
	echo "$0: 不存在训练集目录,现在创建"
	mkdir $data_dir/{train,test,dev}
fi

#现在开始划分数据集
echo "$0: 现在开始划分数据集"
#total存储总的文件个数
#``符号用于存放命令结果并用于赋值
total=`ls $data | wc -l`
#对于wav/data目录下的所有音频文件
i=0
#t1为train集终止条件
t1=$((total*ratio/(ratio+2)))
#t2为test集终止条件
t2=$((total/(ratio+2)+t1))
for x in $data; do
    i=$((i+1))
	if [ $i -le $t1 ]; then 
	cp $x $data_dir/train
    elif [ $i -le $t2 ]; then
    	cp $x $data_dir/test
    else
    	cp $x $data_dir/dev
    fi
done

echo "$0: 按设定的比例 $ratio:1:1 划分完毕"

exit 0;
