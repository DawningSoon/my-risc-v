这是一个用来自学risc-v以及soc设计的小项目，初衷是从零开始搭建处理器，在此感谢B站up主外瑞罗格以及tiny-risc-v项目

交叉编译环境准备：
Ubuntu 22.04

sudo apt update
sudo apt install build-essential gcc make perl dkms git gcc-riscv64-unknown-elf gdb-multiarch qemu-system-misc
sudo apt install gcc-riscv64-linux-gnu


更新日志：

先实现add 
2024/11/19 实现立即数和寄存器add I type和r type待补全 立即数扩展还没做

开始分支

2024/11/20 完成branch与立即数拓展

2024/11/22 complete I/R/J/B type instructions

2024/11/26 简单完成load/store指令，以后有空想实现axi总线的挂载

2024/11/29 添加乘法器

2025/01/15 完成除法器的算法逻辑，实现自己编译的C语言在cpu上运行

2025/01/16 添加start.s用于设置sp寄存器，添加makefile
