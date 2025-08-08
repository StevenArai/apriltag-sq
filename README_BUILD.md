# AprilTag-SQ 构建指南

## 项目状态
✅ **测试通过** - apriltag-sq的Python扩展模块已成功编译并测试通过！

## 文件位置
- **最终whl文件**: `./dist/apriltag_sq-114.514.1919.810-cp313-cp313-linux_x86_64.whl`
- **构建脚本**: `./build_whl.sh` (推荐) 或 `./testwhl.sh` (原始)

## 快速使用

### 1. 安装已构建的包
```bash
pip install ./dist/apriltag_sq-114.514.1919.810-cp313-cp313-linux_x86_64.whl --force-reinstall
```

### 2. 测试安装
```bash
python3 -c "import apriltagsq; print('导入成功！')"
```

### 3. 基本使用示例
```python
import apriltagsq
import numpy as np

# 创建检测器
detector = apriltagsq.apriltagsq('tag36h11')

# 检测图像中的AprilTag
image = np.zeros((480, 640), dtype=np.uint8)  # 替换为实际图像
detections = detector.detect(image)

print(f"找到 {len(detections)} 个标签")
```

## 修改源代码后重新构建

### 方法1: 使用简化脚本 (推荐)
```bash
./build_whl.sh
```

### 方法2: 手动步骤
```bash
# 1. 清理旧文件
rm -rf ./build ./dist ./apriltag_sq.egg-info

# 2. CMake编译
mkdir build && cd build
cmake .. -G Ninja -DBUILD_PYTHON_WRAPPER=ON -DCMAKE_BUILD_TYPE=Release
ninja
cd ..

# 3. 构建Python包
python3 setup.py bdist_wheel

# 4. 安装测试
pip install ./dist/apriltag_sq-*.whl --force-reinstall
python3 -c "import apriltagsq; print('测试成功！')"
```

## 跨平台说明

### Linux (当前平台)
- ✅ 已测试通过
- 生成的whl文件: `*-linux_x86_64.whl`

### Windows
- ❌ 当前的Linux编译的whl文件**不能**在Windows上使用
- 需要在Windows环境下重新编译:
  - 安装Visual Studio Build Tools
  - 安装CMake和Ninja
  - 运行相同的构建步骤

### macOS
- ❌ 需要在macOS环境下重新编译
- 需要安装Xcode Command Line Tools
- 运行相同的构建步骤

## 依赖要求
- Python 3.13 (或其他版本，需要相应调整)
- NumPy
- CMake
- Ninja构建系统
- GCC编译器 (Linux) / MSVC (Windows) / Clang (macOS)

## 故障排除

### 如果导入失败
1. 检查Python版本是否匹配whl文件名中的版本
2. 确保NumPy已安装
3. 重新运行构建脚本

### 如果编译失败
1. 检查是否安装了所有依赖
2. 确保CMake和Ninja可用
3. 检查编译器是否正确安装

## 项目结构
```
apriltag-sq/
├── dist/                          # 构建输出
│   └── apriltag_sq-*.whl         # 最终的wheel包
├── build/                         # CMake构建目录
├── setup.py                       # Python包配置
├── apriltag_pywrap.c              # Python扩展源码
├── build_whl.sh                   # 简化构建脚本
├── testwhl.sh                     # 原始测试脚本
└── README_BUILD.md                # 本文件
