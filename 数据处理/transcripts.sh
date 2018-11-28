#!/bin/bash

#生成标注文件
#注意if语句中判断空格为""
#收工
#csv=$1 #存放csv文件的地址

#if [ ! -f $csv]; then
#	echo "$0: 不存在所需csv文件"
#	exit 1;
#fi

#将csv文件中的"全部替换掉 即删除
sed -i 's/"//g' ./sqlresult_3198008.csv || exit 1;

#根据第5第6个字段是否为数字来判断是否是机器人说的话
#筛选出顾客的语音信息
awk -F',' '{if(NR>1&&($5!="")&&($6!=""))) print $3","$4","$5}' ./sqlresult_3198008.csv > ./newtrans.txt || exit 1;

#用trans生成序号文件
awk -F',' '{if($3!="") print $1}' ./newtrans.txt > ./id.txt || exit 1;
#生成标注文件部分
#去掉机器人说的话 hehe.txt中只保存原csv文件中第四个字段
awk -F',' '{if($3!="") print $2}' ./newtrans.txt > ./hehe.txt || exit 1;

#生成开始时间部分 用于后续的排序用
awk -F',' '{if($3!="") print $3}' ./newtrans.txt > ./time.txt || exit 1;

#对于处理后的中文标注部分去除所有标点符号并在标点符号处添加空格 直接在替换处输入空格即可
sed -e 's/[[:punct:]]/ /g' ./hehe.txt | awk -F' ' '{print " "$0}'> ./biaozhu.txt || exit 1;

#拼贴经过处理后的三列信息
paste -d, ./id.txt ./biaozhu.txt ./time.txt > ./transcripts.txt || exit 1;

#先对相同id的文件进行排序 排序按照时间的先后顺序排
#这里遇到了一个问题 sort排序时将第一和第二个字段的数字拼接在一起进行判断 导致结果错误 
#通过在上一步文件paste之前在第二个字段前加入空格 解决了这一问题
sort -t',' -k 1n -k 3n ./transcripts.txt > ./final.txt || exit 1;



#根据文件在同一id中的顺序在文件id中加入后缀
i=0  #i表示当前序号
id=1   #id表示当前i条件下文件序号
#使用awk中-v 可以添加外部变量 另外$1可能被认定为字符而无法参与比较 id能否直接print输出
awk -v i="$i" id="$id" -F',' '{if(i!=$1){i=$1;id=1;print $1"_"id" "$2" "$3}else {id=id+1;print $1"_"id" "$2" "$3} }' ./final.txt > ./perfect.txt

#rm ./id.txt ./hehe.txt ./time.txt ./biaozhu.txt ./final.txt ./transcripts.txt 
#定义数组var,存储final.txt中第一个字段的说话人id
#line=`cat ./final.txt | wc -l`

