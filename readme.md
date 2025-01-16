# 1.前言
这是一个用来自学risc-v以及soc设计的小项目，初衷是从零开始搭建处理器，在此感谢B站up主外瑞罗格以及tiny-risc-v项目

# 2.项目简介 
1. 目前支持rv32i，以及一部分乘法操作（还在更新中）
2. 三级流水？（应该是）
3. 简单的C语言程序运行
4. 通过寄存器实现的8KB内存

# 3.仿真
目前仿真通过vivado实现

仿真所需的文件在/sim中

新建项目后分别添加/rtl与/sim中的所有文件即可仿真

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





# 5.更新日志：

先实现add 
2024/11/19 实现立即数和寄存器add I type和r type待补全 立即数扩展还没做

开始分支

2024/11/20 完成branch与立即数拓展

2024/11/22 complete I/R/J/B type instructions

2024/11/26 简单完成load/store指令，以后有空想实现axi总线的挂载

2024/11/29 添加乘法器

2025/01/15 完成除法器的算法逻辑，实现自己编译的C语言在cpu上运行

2025/01/16 添加start.s用于设置sp寄存器，添加makefile
