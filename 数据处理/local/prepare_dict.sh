#!/bin/bash

#准备词典资源 主要是生成data/local/dict目录及其下所有文件

. ./path.sh

if [ $# != 1 ] && echo "$0: 参数的个数不为1 " && exit 1;

res_dir=$1
dict_dir=data/local/dict
mkdir -p $dict_dir

#直接将resource_aishell下的字典复制到dict_dir目录下
cp $res_dir/lexicon.txt $dict_dir

#生成非静音音素文件nonsilence_phones.txt
cat $dict_dir/lexicon.txt | awk '{ for(n=2;n<=NF;n++) { phones[$n]=1 }} END{ for ( x in phones ) print x} }' \
| sort -u | perl -e '
  my %ph_cl;
  while(<STDIN>){
  	$phone = $_;
  	chomp($phone);
  	chomp($_);
  	$phone = $_;
  	next if ($phone eq "sil");
  	if (exists $ph_cl{$phone}) { push(@{$ph_cl{$phone}},$_)  }
    else {  $ph_cl{$phone}=[$_]; }
  }
  foreach $key (keys %ph_cl){
  	print "@{ %ph_cl{key} }\n"
  }
' | sort -k1 > $dict_dir/nonsilence_phones.txt || exit 1;

#生成静音音素和可选静音音素表
echo sil > $dict_dir/silence_phones.txt

echo sil > $dict_dir/optional_silence.txt

#生成extra_questions.txt
#将静音音素中的sil和非静音音素中的部分内容加入extra_questions.txt
cat $dict_dir/silence_phones.txt | awk '{printf("%s",$1);} END{printf "\n"; }' > $dict_dir/extra_questions.txt || exit 1;
cat $dict_dir/nonsilence_phones.txt | perl -e 'while(<>){ foreach $p (split(" ", $_)) {
  $p =~ m:^([^\d]+)(\d*)$: || die "Bad phone $_"; $q{$2} .= "$p "; } } foreach $l (values %q) {print "$l\n";}' \
 >> $dict_dir/extra_questions.txt || exit 1;

 echo "$0: aisehll 字典准备阶段已完成"
 exit 0;