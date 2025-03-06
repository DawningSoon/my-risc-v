# 定义工具链和选项
CC = riscv64-unknown-elf-gcc
OBJDUMP = riscv64-unknown-elf-objdump
CFLAGS = -march=rv32im -mabi=ilp32 -nostdlib
LDFLAGS = -march=rv32im -nostartfiles -nostdlib -T linker.lds -e _start

# 文件路径
SRCS = start.s test.c
OBJS = start.o test.o
ELF = test.elf
DUMP = test.txt
DEST = /mnt/hgfs/temp/

# 默认目标
all: $(ELF) dump copy

# 编译 C 文件
test.o: test.c
	$(CC) $(CFLAGS) -c $< -o $@

# 编译汇编文件
start.o: start.s
	$(CC) $(CFLAGS) -c $< -o $@

# 链接生成 ELF 文件
$(ELF): $(OBJS) linker.lds
	$(CC) $(LDFLAGS) $(OBJS) -o $@

# 反汇编生成 dump 文件
dump: $(ELF)
	$(OBJDUMP) -d $(ELF) > $(DUMP)

# 复制 dump 文件到指定路径
copy: dump
	cp $(DUMP) $(DEST)

# 清理生成的文件
clean:
	rm -f $(OBJS) $(ELF) $(DUMP)

# 声明伪目标
.PHONY: all dump copy clean

