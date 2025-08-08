#!/bin/bash

set -e

# 检查是否提供了目标平台参数
if [ -z "$1" ]; then
    echo "错误: 未提供目标平台。"
    echo "用法: $0 [aarch64|riscv64]"
    exit 1
fi

TARGET_ARCH=$1

# 根据目标平台设置环境变量
if [ "$TARGET_ARCH" == "aarch64" ]; then
    export TARGET_TRIPLET="aarch64-linux-gnu"
    export PLATFORM_TAG="manylinux_2_17_aarch64"
elif [ "$TARGET_ARCH" == "riscv64" ]; then
    export TARGET_TRIPLET="riscv64-linux-gnu"
    export PLATFORM_TAG="manylinux_2_17_riscv64"
    # 为RISC-V设置特定的编译标志
    export ARCH_CFLAGS="-march=rv64imafdc -mabi=lp64d"
else
    echo "错误: 不支持的目标平台 '$TARGET_ARCH'。"
    echo "可用平台: aarch64, riscv64"
    exit 1
fi

echo "=== 开始为 $TARGET_ARCH 交叉编译wheel包 ==="

# 设置交叉编译工具链的环境变量
export CC="${TARGET_TRIPLET}-gcc"
export CXX="${TARGET_TRIPLET}-g++"
export LDSHARED="${CC} -shared"
export AR="${TARGET_TRIPLET}-ar"
export RANLIB="${TARGET_TRIPLET}-ranlib"
export READELF="${TARGET_TRIPLET}-readelf"
export STRIP="${TARGET_TRIPLET}-strip"

# 欺骗 setuptools，让它认为我们在目标平台上
# 这是交叉编译Python C扩展的关键技巧
export _PYTHON_HOST_PLATFORM="linux_${TARGET_ARCH}"
# 动态获取主机的sysconfigdata名称，以避免ModuleNotFoundError
SYSCONFIGDATA_NAME=$(python3 -c "import sysconfig; print(sysconfig._get_sysconfigdata_name())")
export _PYTHON_SYSCONFIGDATA_NAME=$SYSCONFIGDATA_NAME

# 清理旧的构建文件
echo "--> 正在清理旧的构建文件..."
rm -rf ./build ./dist ./apriltag_sq.egg-info

# --- 阶段 1: 为本机生成代码 ---
# 这一步与平台无关，我们只需要CMake为我们生成docstring头文件。
# 我们为本机(host)运行CMake，这样它可以找到Python和NumPy。
echo "--> 阶段 1: 为本机生成docstring头文件..."
mkdir -p build_host
cd build_host
cmake .. -G Ninja
ninja apriltag_py_docstrings
cd ..

# --- 阶段 2: 交叉编译Python Wheel ---
# setup.py 会使用上面设置的环境变量来进行交叉编译。
# 我们需要确保它能找到阶段1中生成的头文件。
echo "--> 阶段 2: 使用 setup.py 交叉编译wheel包..."
# 将生成的头文件路径添加到包含路径中
export CFLAGS="-I$(pwd)/build_host ${ARCH_CFLAGS:-}"  # 如果ARCH_CFLAGS未设置则为空
python3 setup.py bdist_wheel --plat-name $PLATFORM_TAG

# 显示结果
echo ""
echo "=== 交叉编译完成 ==="
echo "为 $TARGET_ARCH 生成的wheel文件位于:"
ls -lh dist/*.whl
