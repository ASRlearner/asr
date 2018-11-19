#!/bin/bash

#你可以取决于使用什么类型的集群来修改该脚本文件。
#如果你没有集群系统并且希望在本机运行，你可以把所有的queue.pl转变成run.pl
export train_cmd=run.pl
export mkgraph_cmd=run.pl
export decode_cmd=run.pl
export cuda_cmd=run.pl