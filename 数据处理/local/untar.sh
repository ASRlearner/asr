#!/bin/bash

#Copyright     2018   ZheJiang University (smz)
#这个是对aishell数据集的处理文件，只能用于处理aishell数据集
#aishell数据集的格式为
#     两个压缩文件data_aishell 和 resource_aishell 
#     其中data_aishell下两个目录 标注和wav目录 wav下存放所有说话人压缩文件 
#                                            而标注下存放了标注文件
#     resource_aishell下存放了字典lexicon.txt和speaker.info 说话人性别信息

#判断参数个数是否符合要求
if [ $# -ne 2 ]; then
	echo "参数个数不匹配"
	echo "请输入正确参数个数"
	exit 1;
fi

data=$1     #f/kaldili例子/aishell-data 数据存放目录
part=$2     #data_aishell/resource_aishell  数据分目录

#判断aishell-data是否是目录
if [ ! -d $data ]; then
	echo "$0: 不存在目录 $data"
	exit 1;
fi

#用于判断part中存放的参数是否为data_aishell和resource_aishell中一个
part_ok=false
list="data_aishell resource_aishell"
for x in $list;do
	if [ "$part" == $x ]; then
		part_ok=true;
	fi
done

#如果参数不匹配则报错
if ! $part_ok; then
	echo "$0: 想要得到目录 $list 的其中一个,却得到 '$part'"
	exit 1;
fi

#判断数据是否已经解压完毕，如果解压完毕则直接正常退出
if [ -f $data/$part/.complete ]; then
	echo "$0: 数据部分 $part 已经成功提取,没什么需要做的了"
	exit 0;
fi

#移动到数据目录下 开始解压数据文件
cd $data

if ! tar -xvzf $part.tgz; then
	echo "$0: 解压文件 $data/$part.tgz 失败"
	exit 1;
fi

#修改数据目录下所有文件的访问和修改时间
touch $data/$part/.complete

#如果当前处理的是data_aishell目录则继续解压
if [ $part == "data_aishell" ]; then
	cd $part/wav
	for x in ./*.tar.gz; do
		#对于wav目录下的每一个wav文件解压并且移除原压缩文件
		echo "从 $x 中提取wav文件"
		tar -zxf $x && rm $x
	done
fi

echo "$0: 成功解压 $data/$part.tgz"

exit 0;


