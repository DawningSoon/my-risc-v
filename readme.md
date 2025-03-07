# 1.前言
这是一个用来自学risc-v以及soc设计的小项目，初衷是从零开始搭建处理器，在此感谢B站up主外瑞罗格以及tiny-risc-v项目

# 2.项目简介 
1. 目前支持rv32im
2. 四级流水（比no-bram版本多了一级取指）
3. 简单的C语言程序运行
4. 通过Xilinx的block memory generator生成的双口bram实现rom和ram，在no-bram分支中有通过寄存器实现的版本
5. 可综合

# 3.仿真
目前仿真通过vivado实现

仿真所需的文件在/sim中

新建项目后分别添加/rtl与/sim中的所有文件

在tb中需要例化soc_top.v中的top与ahb_bridge.v具体可以参考/sim/tb.v

bram通过xilinx的block memory generator生成,具体配置如下图所示，深度可根据需求更改

![alt text](/docs/bram1.png)

![alt text](/docs/bram2.png)

![alt text](/docs/bram3.png)

将指令代码复制到/sim/test.c中，通过/sim/txt_to_coe.py生成coe文件

将coe文件添加到bram的初始数据中并重新生成bram

进行行为级仿真

/sim/inst_txt和/sim/generated中是一些指令测试代码，具体用法可以参考外瑞罗格的视频以及tiny-risc-v项目

# 4.交叉编译与C语言代码运行

## 4.1交叉编译环境准备：

Linux系统：Ubuntu 22.04

1. 下载工具链

```
sudo apt update
sudo apt install build-essential gcc make perl dkms git gcc-riscv64-unknown-elf gdb-multiarch qemu-system-misc
sudo apt install gcc-riscv64-linux-gnu
```

2. 配置环境变量

在.bashrc中添加

`export PATH=$PATH:/usr/lib/riscv64-unknown-elf/bin`

## 4.2编译

test.c中是一个简单的示例（复杂的例子我还没试）

修改其中的代码直接make就行

复杂代码的编译要自己写makefile和link

## 4.3运行

1. 将编译生成的test.txt修改成只包含机器码的形式（要是有好心人能用python帮我写一个就好了）

![alt text](image.png)

2. 将test.txt放到/sim中

3. 通过/sim/txt_to_coe.py将txt转为coe

由于现在没有接外设，输出只能从寄存器和内存来看了



# 5.更新日志：

先实现add 
2024/11/19 实现立即数和寄存器add I type和r type待补全 立即数扩展还没做

开始分支

2024/11/20 完成branch与立即数拓展

2024/11/22 complete I/R/J/B type instructions

2024/11/26 简单完成load/store指令

2024/11/29 添加乘法器

2025/01/15 完成除法器的算法逻辑，实现自己编译的C语言在cpu上运行

2025/01/16 添加start.s用于设置sp寄存器，添加makefile

2025/02/25 完成rv32m

2025/02/28 忽略存储器后（ram和rom）可综合

2025/03/06 实现ahb_lite总线的搭载，可以通过总线连接内存与外设，用bram实现ram与rom
