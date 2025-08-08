#!/bin/bash

echo "=== 构建apriltag-sq wheel包 ==="

# 清理旧的构建文件
echo "清理旧的构建文件..."
rm -rf ./build ./dist ./apriltag_sq.egg-info

# 创建build目录并使用cmake编译
echo "使用CMake编译项目..."
mkdir build
cd build
cmake .. -G Ninja -DBUILD_PYTHON_WRAPPER=ON -DCMAKE_BUILD_TYPE=Release
ninja
cd ..

# 构建wheel包
echo "构建Python wheel包..."
python3 setup.py bdist_wheel

# 显示结果
echo "=== 构建完成 ==="
echo "生成的wheel文件："
ls -la dist/*.whl

echo ""
echo "安装命令："
echo "pip install ./dist/apriltag_sq-114.514.1919.810-cp313-cp313-linux_x86_64.whl --force-reinstall"

echo ""
echo "测试命令："
echo "python3 -c \"import apriltagsq; print('导入成功！')\""
