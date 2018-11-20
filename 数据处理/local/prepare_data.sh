#!/bin/bash

#数据准备：最重要的部分
. ./path.sh || exit 1;

if [ $# != 2 ]; then
	echo "$0: 参数个数不为2"
	exit 1;
fi

aishell