from setuptools import setup, Extension
import numpy as np
import os

# 需要先生成docstring头文件
def generate_docstrings():
    build_dir = 'build_host' # 在交叉编译时，我们从一个单独的host构建目录读取
    if not os.path.exists(build_dir):
        # 如果host构建目录不存在，检查本地构建目录作为备选
        build_dir = 'build'
        if not os.path.exists(build_dir):
            return False
    
    docstring_files = [
        'apriltag_detect_docstring.h',
        'apriltag_py_type_docstring.h'
    ]
    
    for f in docstring_files:
        if not os.path.exists(os.path.join(build_dir, f)):
            return False
    return True

if not generate_docstrings():
    print("需要先运行cmake构建来生成docstring文件")
    import sys
    sys.exit(1)

ext_modules = [
    Extension(
        'apriltagsq',
        sources=[
            'apriltag_pywrap.c',
            'apriltag.c',
            'apriltag_pose.c', 
            'apriltag_quad_thresh.c',
            'common/g2d.c',
            'common/getopt.c',
            'common/homography.c',
            'common/image_u8.c',
            'common/image_u8x3.c',
            'common/image_u8x4.c',
            'common/matd.c',
            'common/pam.c',
            'common/pjpeg-idct.c',
            'common/pjpeg.c',
            'common/pnm.c',
            'common/pthreads_cross.c',
            'common/string_util.c',
            'common/svd22.c',
            'common/time_util.c',
            'common/unionfind.c',
            'common/workerpool.c',
            'common/zarray.c',
            'common/zhash.c',
            'common/zmaxheap.c',
            'tag16h5.c',
            'tag25h9.c',
            'tag36h10.c',
            'tag36h11.c',
            'tagCircle21h7.c',
            'tagCircle49h12.c',
            'tagCustom48h12.c',
            'tagStandard41h12.c',
            'tagStandard52h13.c',
        ],
        include_dirs=[
            '.',
            'common',
            'build_host', # 交叉编译时使用
            'build',      # 本地编译时使用
            np.get_include(),
        ],
        libraries=['m', 'pthread'],
        define_macros=[('NPY_NO_DEPRECATED_API', 'NPY_API_VERSION')],
    )
]

setup(
    name='apriltag-sq',
    version='114.514.1919.810',
    description='Apriltag with square detection exposed.',
    ext_modules=ext_modules,
    install_requires=['numpy'],
)
