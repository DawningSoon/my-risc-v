.section .text
.global _start

_start:
    # 初始化堆栈指针 (假设堆栈地址为 0x80000000)
    la sp, 0x2000  

    # 跳转到 main 函数
    call main

    # 如果 main 返回，进入死循环
hang:
    j hang
