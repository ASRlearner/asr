#!/bin/bash

#数据准备：最重要的部分
. ./path.sh || exit 1;

if [ $# != 2 ]; then
	echo "$0: 参数个数不为2"
	exit 1;
fi

# $data/data_aishell/wav   参数1
# $data/data_aishell/transcript   参数2
# transcripts文件存储语音序号 以及对应的文本内容
aishell_audio_dir=$1
aishell_text=$2/transcript.txt

#生成四个目录 其中tmp存放临时标注文件
train_dir=data/local/train
test_dir=data/local/test
dev_dir=data/local/dev
tmp_dir=data/local/tmp

#创建对应目录
mkdir -p $train_dir
mkdir -p $test_dir
mkdir -p $dev_dir
mkdir -p $tmp_dir

#判断所需文件是否都已存在
if [ ! -d $aishell_audio_dir ] || [ ! -f $aishell_text ]; then
	echo "$0: $aishell_audio_dir 或者 $aishell_text 中至少有一个文件不存在"
	exit 1;
fi

#使用find命令查找文件的路径
#生成tmp目录下的wav.flist文件 存放所有音频文件的存放路径
find $aishell_audio_dir -iname "*.wav" > $tmp_dir/wav.flist

#判断音频文件数量是否符合要求
#n=`cat $tmp_dir/wav.flist | wc -l`
#[ $n -ne 141925 ] && \
#  echo Warning: expected 141925 data data files, found $n

#生成各自目录下的wav.flist文件
#通过提取tmp目录下wav.flist中带有对应字段的行重定向到对应目录下的wav.flist
grep -i "wav/train" $tmp_dir/wav.flist > $train_dir/wav.flist || exit 1;
grep -i "wav/test" $tmp_dir/wav.flist > $test_dir/wav.flist || exit 1;
grep -i "wav/dev" $tmp_dir/wav.flist > $dev_dir/wav.flist || exit 1;

#移除临时文件夹tmp
rm -r $tmp_dir

#开始生成标注文件
for dir in $train_dir $test_dir $dev_dir; do
	echo 开始 $dir 目录下的标注文件生成
	#生成对应目录下的语音列表文件utt.list(只包含语音文件的名称而不带后缀)
	sed -e 's/\.wav//' $dir/wav.flist | awk -F '/' '{print $NF}' > $dir/utt.list
	#生成语音到说话人的映射文件utt2spk_all(语音id 说话人id)
	sed -e 's/\.wav//' $dir/wav.flist | awk -F '/' '{ i=NF-1; printf("%s %s\n",$NF,$i )}' > $dir/utt2spk_all
    #生成对应wav.scp_all文件 存放语音以及对应的文件路径(语音id 语音路径)
    paste -d' ' $dir/utt.list $dir/wav.flist > $dir/wav.scp_all
    #使用filter_scp.pl文件过滤$aishell_text中$dir/utt.list文件中存在的语音id 将id到文本内容的对应关系
    #输出到$dir/transcripts.txt中
    #使用utils/filter_scp.pl 输入语音id 以及标注文件 生成对应目录下transcripts.txt文件
    utils/filter_scp.pl -f 1 $dir/utt.list $aishell_text > $dir/transcripts.txt
    #输出对应文件夹下标注文件中第一个字段即语音id到对应目录下utt.list文件中
    awk '{print $1}' $dir/transcripts.txt > $dir/utt.list
    #生成$dir目录下的utt2spk文件(语音id 说话人id)
    utils/filter_scp.pl -f 1 $dir/utt.list $dir/utt2spk_all | sort -u > $dir/utt2spk
    #生成#dir目录下的wav.scp文件(语音id 语音路径)
    utils/filter_scp.pl -f 1 $dir/utt.list $dir/wav.scp_all | sort -u > $dir/wav.scp
    #生成$dir目录下的text文件(语音id 文本标注)
    sort -u $dir/transcripts.txt > $dir/text
    #生成spk2utt文件
    utils/utt2spk_to_spk2utt.pl $dir/utt2spk > $dir/spk2utt
done

#创建目录data/train data/test data/dev
mkdir -p data/train data/test data/dev

#将对应目录下的spk2utt utt2spk wav.scp text文件复制到相应目录下
for x in spk2utt utt2spk wav.scp text; do
	cp $train_dir/$x data/train/$x || exit 1;
	cp $dev_dir/$x data/dev/$x || exit 1;
	cp $test_dir/$x data/test/$x || exit 1;
done

echo "$0: aishell 数据已经全部准备完毕"
exit 0;
