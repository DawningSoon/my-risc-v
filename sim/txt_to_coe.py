def txt_to_coe(input_file, output_file, radix=16):
    """
    将txt文件转换为coe文件。

    :param input_file: 输入的txt文件路径
    :param output_file: 输出的coe文件路径
    :param radix: 数据的基数（16表示十六进制）
    """
    try:
        with open(input_file, 'r') as txt_file:
            lines = txt_file.readlines()

        with open(output_file, 'w') as coe_file:
            # 写入COE文件头部
            coe_file.write("memory_initialization_radix = {};\n".format(radix))
            coe_file.write("memory_initialization_vector =\n")

            # 写入数据
            for i, line in enumerate(lines):
                line = line.strip()
                if line:
                    # 检查是否为8位十六进制数
                    if len(line) != 8 or not all(c in "0123456789ABCDEFabcdef" for c in line):
                        raise ValueError(f"输入文件中的行 '{line}' 不是有效的8位十六进制数")
                    if i != len(lines) - 1:
                        coe_file.write(line + ",\n")
                    else:
                        coe_file.write(line + ";\n")

        print(f"转换成功！输出文件为: {output_file}")

    except Exception as e:
        print(f"转换失败: {e}")

if __name__ == "__main__":
    # 输入文件和输出文件路径
    input_txt = "E:/file/my-risc-v/sim/test.txt"  # 替换为你的输入txt文件路径
    output_coe = "E:/file/my-risc-v/sim/output.coe"  # 替换为你的输出coe文件路径

    # 选择基数（16表示十六进制）
    radix = 16

    # 调用转换函数
    txt_to_coe(input_txt, output_coe, radix)