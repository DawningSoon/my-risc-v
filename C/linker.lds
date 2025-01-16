ENTRY(main)

MEMORY {
    RAM (rwx) : ORIGIN = 0x0000, LENGTH = 0x2000  /* 可用内存范围 */
}

SECTIONS {
    . = 0x0000;
    
    .text : {
        *(.text)  /* 代码段 */
    }>RAM

    .data : { *(.data)  /* 数据段 */ }

    .bss : {
        *(.bss)   /* BSS 段，未初始化的全局变量 */
    }>RAM

    .stack (NOLOAD) : {
         . = 0x1000;  /* 设置栈顶的地址为 0x2000 */
        stack_top = .;  /* 标记栈顶位置 */
        *(.stack)  /* 栈空间 */
    }>RAM
}