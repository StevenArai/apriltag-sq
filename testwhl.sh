#! /bin/bash
rm -rf ./build
mkdir build
cd build
cmake .. -G Ninja -DBUILD_PYTHON_WRAPPER=ON -DCMAKE_BUILD_TYPE=Release
ninja
cd ..
python3 setup.py bdist_wheel
pip install ./dist/apriltag_sq-114.514.1919.810-cp313-cp313-linux_x86_64.whl --force-reinstall
python3 -c "import apriltagsq"
