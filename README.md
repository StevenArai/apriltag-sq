新接口 `detect_quads` 的用法其实很直观，可以总结成这样：

1. **创建检测器实例**

   ```python
   detector = apriltagsq.apriltagsq('tag36h11')
   ```

   * 参数 `'tag36h11'` 指定了标签族（和原版 `detect` 一样）。
   * `apriltagsq` 类现在多了一个 `detect_quads` 方法。

2. **准备灰度图像**

   ```python
   img = Image.open('input.png').convert('L')
   image_data = np.array(img)
   ```

   * `detect_quads` 接口直接接受 **二维 `numpy` 灰度数组**，而不是彩色图。

3. **调用新接口**

   ```python
   quads = detector.detect_quads(image_data)
   ```

   * 返回值是一个 **Python `list`**，列表中每个元素代表一个检测到的四边形。
   * 每个四边形是 **形状为 `(4, 2)` 的 `numpy.ndarray`**，依次是四个角点的 `(x, y)` 浮点坐标。

4. **典型返回数据结构**

   ```python
   [
       np.array([[x1, y1],
                 [x2, y2],
                 [x3, y3],
                 [x4, y4]], dtype=float),
       ...
   ]
   ```

   * 不包含标签ID、Hamming距离、姿态等信息，只保留几何轮廓。

---

所以对比原版 `detect`：

* 原版返回的是包含 **ID、置信度、姿态** 等的检测对象；
* `detect_quads` 只返回四边形坐标。

5. **测试程序**

  ```python
    
import apriltagsq
import numpy as np
from PIL import Image

print('--- 测试新 detect_quads 接口 ---')

try:
    # 1. 创建检测器
    detector = apriltagsq.apriltagsq('tag36h11')
    print('✅ 检测器创建成功')

    # 2. 加载测试图像并转为灰度
    try:
        img = Image.open('input.png').convert('L')
        image_data = np.array(img)
        print(f'✅ 图像加载成功, 尺寸: {image_data.shape}')
    except FileNotFoundError:
        print('❌ 测试图像 input.png 未找到, 将使用空白图像')
        image_data = np.zeros((480, 640), dtype=np.uint8)

    # 3. 调用 detect_quads
    quads = detector.detect_quads(image_data)
    print(f'✅ detect_quads 调用完成')

    # 4. 验证结果
    print(f'结果: 检测到 {len(quads)} 个四边形')
    assert isinstance(quads, list), f'返回类型应为 list, 但得到 {type(quads)}'
    
    if len(quads) > 0:
        first_quad = quads[0]
        print('第一个四边形的数据类型:', type(first_quad))
        assert isinstance(first_quad, np.ndarray), f'列表元素应为 numpy.ndarray, 但得到 {type(first_quad)}'
        
        print('第一个四边形的形状:', first_quad.shape)
        assert first_quad.shape == (4, 2), f'四边形数组形状应为 (4, 2), 但得到 {first_quad.shape}'
        
        print('第一个四边形的角点坐标:')
        print(first_quad)
    
    print('\\n✅ 所有测试通过！新接口工作正常。')

except Exception as e:
    print(f'❌ 测试失败: {e}')
```
将仓库根目录下的`input.png`置于工作目录，运行脚本，即可检查apriltag-sq是否被正确构建&安装。
