# YOLOv1:

## 结构：

单纯的卷积、池化最后加了两层全连接。但看网络结构和普通的`CNN`对象分类网络几乎没有本质的区别，最大的差异是最后输出层用线性函数做激活函数，因为需要预测`bounding box`的位置（数值型），而不仅仅是对象的概率。所以粗略来说，`YOLO`的整个结构就是输入图片经过神经网络的变换得到一个输出的张量

## 输入和输出的映射关系：

![preview](https://pic4.zhimg.com/v2-33df11dea3ad6ba31fccb709f26fc1d3_r.jpg)

## 输入

参考图5，输入就是原始图像，唯一的要求是缩放到`448*448`的大小。主要是因为`YOLO`的网络中，卷积层最后接了两个全连接层，全连接层是要求固定大小的向量作为输入，所以倒推回去也就要求原始图像有固定的尺寸。那么`YOLO`设计的尺寸就是`448*448`。

## 输出

输出是一个 `7*7*30` 的张量`（tensor）`。

### 7*7网格

并不是说仅仅网格内的信息被映射到一个30维向量，经过神经网络对输入图像信息的提取和变换，网格周围的信息也会被识别和整理，最后编码到那个30维向量中。

### 30维向量

![img](https://pic1.zhimg.com/80/v2-6c421d06d70a1906b12ca057dfa92d0c_720w.jpg)

#### 20个对象分类的概率

因为YOLO支持识别20种不同的对象（人、鸟、猫、汽车、椅子等），所以这里有20个值表示该网格位置存在任一种对象的概率。可以记为 ![[公式]](https://www.zhihu.com/equation?tex=P%28C_1%7CObject%29%2C+......%2C+P%28C_i%7CObject%29%2C......P%28C_%7B20%7D%7CObject%29) ，之所以写成条件概率，意思是如果该网格存在一个对象Object，那么它是 ![[公式]](https://www.zhihu.com/equation?tex=C_i) 的概率是 ![[公式]](https://www.zhihu.com/equation?tex=P%28C_i%7CObject%29) 。

#### 2个bounding box的位置

每个`bounding box`需要4个数值来表示其位置，`(Center_x,Center_y,width,height)`，即(`bounding box`的中心点的`x`坐标，`y`坐标，`bounding box`的宽度，高度)，2个`bounding box`共需要8个数值来表示其位置。

#### 2个bounding box的置信度

bounding box的置信度 = 该bounding box内存在对象的概率 * 该bounding box与该对象实际bounding box的IOU

![[公式]](https://www.zhihu.com/equation?tex=%5C%5C+Confidence+%3D+Pr%28Object%29++%2A+IOU_%7Bpred%7D%5E%7Btruth%7D+)

## 讨论

1. 一张图片最多可以检测49个对象 

   每一个30维向量中只有一组（20个）对象分类的概率，也就只能预测出一个对象。

2. 总共有49*2 = 98个候选区

3. YOLO的bounding box并不是Faster RCNN的Anchor

   YOLO的2个bounding box事先并不知道会在什么位置，只有经过前向计算，网络会输出2个bounding box，这两个bounding box与样本中对象实际的bounding box计算IOU。这时才能确定，IOU值大的那个bounding box，作为负责预测该对象的bounding box。

   训练开始阶段，网络预测的bounding box可能都是乱来的，但总是选择IOU相对好一些的那个，随着训练的进行，每个bounding box会逐渐擅长对某些情况的预测（可能是对象大小、宽高比、不同类型的对象等）。所以，这是一种进化或者非监督学习的思想。

   另外论文中经常提到**responsible**。比如：Our system divides the input image into an S*S grid. If the center of an object falls into a grid cell, that grid cell is responsible for detecting that object. 这个 responsible 有点让人疑惑，对预测"负责"是啥意思。其实没啥特别意思，就是一个Object只由一个grid来进行预测，不要多个grid都抢着预测同一个Object。更具体一点说，就是在设置训练样本的时候，样本中的每个Object归属到且仅归属到一个grid，即便有时Object跨越了几个grid，也仅指定其中一个。具体就是计算出该Object的bounding box的中心位置，这个中心位置落在哪个grid，该grid对应的输出向量中该对象的类别概率是1（该gird负责预测该对象），所有其它grid对该Object的预测概率设为0（不负责预测该对象）。

4. 可以调整网格数量，bounding box的数量

   ​	`7*7`网格，每个网格2个bounding box，对`448*448`输入图像来说覆盖粒度有点粗。我们也可以设置更多的网格以及更多的bounding box。设网格数量为 `S*S`，每个网格产生B个边框，网络支持识别C个不同的对象。这时，输出的向量长度为：

   ![[公式]](https://www.zhihu.com/equation?tex=%5C%5C+C+%2B+B+%2A+%284%2B1%29+)

   整个输出的tensor就是：

![[公式]](https://www.zhihu.com/equation?tex=%5C%5C+S+%2A+S+%2A+%28C+%2B+B+%2A+%284%2B1%29%29+)

​		YOLO选择的参数是 7*7网格，2个bounding box，20种对象，因此 输出向量长度 = 20 + 2 * (4+1) = 30。整个输出的tensor就是 `7*7*30`。

## 训练样本构造

作为监督学习，我们需要先构造好训练样本，才能让模型从中学习。

![img](https://pic3.zhimg.com/80/v2-17c92e768f2f0e379f96a197bd0ec842_720w.jpg)

### 20个对象分类的概率

对于输入图像中的每个对象，先找到其中心点。比如图8中的自行车，其中心点在黄色圆点位置，中心点落在黄色网格内，所以这个黄色网格对应的30维向量中，自行车的概率是1，其它对象的概率是0。所有其它48个网格的30维向量中，该自行车的概率都是0。这就是所谓的"中心点所在的网格对预测该对象负责"。狗和汽车的分类概率也是同样的方法填写。

### 2个bounding box的位置

训练样本的bounding box位置应该填写对象实际的bounding box，但一个对象对应了2个bounding box，该填哪一个呢？上面讨论过，需要根据网络输出的bounding box与对象实际bounding box的IOU来选择，所以要在训练过程中动态决定到底填哪一个bounding box。

上面讨论过置信度公式 ![[公式]](https://www.zhihu.com/equation?tex=%5C%5C+Confidence+%3D+Pr%28Object%29++%2A+IOU_%7Bpred%7D%5E%7Btruth%7D+) ![[公式]](https://www.zhihu.com/equation?tex=IOU_%7Bpred%7D%5E%7Btruth%7D) 可以直接计算出来，就是用网络输出的2个bounding box与对象真实bounding box一起计算出IOU。

然后看2个bounding box的IOU，哪个比较大（更接近对象实际的bounding box），就由哪个bounding box来负责预测该对象是否存在，即该bounding box的 ![[公式]](https://www.zhihu.com/equation?tex=Pr%28Object%29+%3D1) ，同时对象真实bounding box的位置也就填入该bounding box。另一个不负责预测的bounding box的 ![[公式]](https://www.zhihu.com/equation?tex=Pr%28Object%29+%3D0) 。

总的来说就是，与对象实际bounding box最接近的那个bounding box，其 ![[公式]](https://www.zhihu.com/equation?tex=Confidence%3DIOU_%7Bpred%7D%5E%7Btruth%7D) ，该网格的其它bounding box的 ![[公式]](https://www.zhihu.com/equation?tex=Confidence%3D0)

## 例子：

比如上图中自行车的中心点位于4行3列网格中，所以输出tensor中4行3列位置的30维向量如下图所示。

![img](https://pic3.zhimg.com/80/v2-1e899c7d3527c8951724232c73b2bcce_720w.jpg)

4行3列网格位置有一辆自行车，它的中心点在这个网格内，它的位置边框是bounding box1所填写的自行车实际边框。

图中将自行车的位置放在bounding box1，但实际上是在训练过程中等网络输出以后，比较两个bounding box与自行车实际位置的IOU，自行车的位置（实际bounding box）放置在IOU比较大的那个bounding box（图中假设是bounding box1），且该bounding box的置信度设为1（在u预测结果出来之后再赋值的）。

## 损失函数：

**损失就是网络实际输出值与样本标签值之间的偏差。**

![preview](https://pic4.zhimg.com/v2-b5dcfc68cab66010a12fb375fcc1ea5b_r.jpg)

YOLO给出的损失函数如下：

![img](https://pic1.zhimg.com/80/v2-e09d0d22173276a231c310d93617fc24_720w.jpg)

**网络输出与样本标签的各项内容的误差平方和作为一个样本的整体误差。 损失函数中的几个项是与输出的30维向量中的内容相对应的。**

## 训练：

YOLO先使用ImageNet数据集对前20层卷积网络进行预训练，然后使用完整的网络，在PASCAL VOC数据集上进行对象识别和定位的训练和预测。YOLO的网络结构如下图所示：

![img](https://pic3.zhimg.com/80/v2-9011aa1a598d548329a40428cc89ee22_720w.jpg)

YOLO的最后一层采用线性激活函数，其它层都是`Leaky ReLU`。训练中采用了drop out和数据增强（data augmentation）来防止过拟合。

## 预测：

训练好的YOLO网络，输入一张图片，将输出一个` 7*7*30` 的张量（tensor）来表示图片中所有网格包含的对象（概率）以及该对象可能的2个位置（bounding box）和可信程度（置信度）。 为了从中提取出最有可能的那些对象和位置，YOLO采用NMS（Non-maximal suppression，非极大值抑制）算法（选择得分最高的作为输出，与该输出重叠的去掉，不断重复这一过程直到所有备选处理完）。

# YOLOV2

## Batch Normalization

Batch Normalization可以提升模型收敛速度，而且可以起到一定正则化效果，降低模型的过拟合。在YOLOv2中，每个卷积层后面都添加了Batch Normalization层，并且不再使用droput。使用Batch Normalization后，YOLOv2的mAP提升了2.4%。

## **Convolutional With Anchor Boxes**

YOLOv2借鉴了Faster R-CNN中RPN网络的先验框（anchor boxes，prior boxes，SSD也采用了先验框）策略。

YOLOv2移除了YOLOv1中的全连接层而采用了卷积和anchor boxes来预测边界框。为了使检测所用的特征图分辨率更高，移除其中的一个pool层。在检测模型中，YOLOv2不是采用 ![[公式]](https://www.zhihu.com/equation?tex=448%5Ctimes448) 图片作为输入，而是采用 ![[公式]](https://www.zhihu.com/equation?tex=416%5Ctimes416) 大小。因为YOLOv2模型下采样的总步长为 ![[公式]](https://www.zhihu.com/equation?tex=32) ，对于 ![[公式]](https://www.zhihu.com/equation?tex=416%5Ctimes416) 大小的图片，最终得到的特征图大小为 ![[公式]](https://www.zhihu.com/equation?tex=13%5Ctimes13) ，维度是奇数，这样特征图恰好只有一个中心位置。对于一些大物体，它们中心点往往落入图片中心位置，此时使用特征图的一个中心点去预测这些物体的边界框相对容易些。

## Dimension Cluster

YOLOv2采用k-means聚类方法对训练集中的边界框做了聚类分析。因为设置先验框的主要目的是为了使得预测框与ground truth的IOU更好，所以聚类分析时选用box与聚类中心box之间的IOU值作为距离指标：

## New NetWork: DarkNet-19

YOLOv2采用了一个新的基础模型（特征提取器），称为Darknet-19，包括19个卷积层和5个maxpooling层，如图4所示。Darknet-19与VGG16模型设计原则是一致的，主要采用 ![[公式]](https://www.zhihu.com/equation?tex=3%5Ctimes3) 卷积，采用 ![[公式]](https://www.zhihu.com/equation?tex=2%5Ctimes2) 的maxpooling层之后，特征图维度降低2倍，而同时将特征图的channles增加两倍。与NIN([Network in Network](https://link.zhihu.com/?target=https%3A//arxiv.org/abs/1312.4400))类似，Darknet-19最终采用global avgpooling做预测，并且在 ![[公式]](https://www.zhihu.com/equation?tex=3%5Ctimes3) 卷积之间使用 ![[公式]](https://www.zhihu.com/equation?tex=1%5Ctimes1) 卷积来压缩特征图channles以降低模型计算量和参数。Darknet-19每个卷积层后面同样使用了batch norm层以加快收敛速度，降低模型过拟合。在ImageNet分类数据集上，Darknet-19的top-1准确度为72.9%，top-5准确度为91.2%，但是模型参数相对小一些。使用Darknet-19之后，YOLOv2的mAP值没有显著提升，但是计算量却可以减少约33%。

![preview](https://pic4.zhimg.com/v2-6b500d1b8bc35c53191daa65eb49f56f_r.jpg)

## **Direct location prediction**

沿用YOLOv1的方法，就是预测边界框中心点相对于对应cell左上角位置的相对偏移值，为了将边界框中心点约束在当前cell中，使用sigmoid函数处理偏移值，这样预测的偏移值在(0,1)范围内（每个cell的尺度看做1）。总结来看，根据边界框预测的4个offsets ![[公式]](https://www.zhihu.com/equation?tex=t_x%2C+t_y%2C+t_w%2C+t_h) ，可以按如下公式计算出边界框实际位置和大小：

![[公式]](https://www.zhihu.com/equation?tex=%5C%5Cb_x+%3D+%5Csigma+%28t_x%29%2Bc_x)

![[公式]](https://www.zhihu.com/equation?tex=%5C%5Cb_y+%3D+%5Csigma+%28t_y%29+%2B+c_y)

![[公式]](https://www.zhihu.com/equation?tex=%5C%5Cb_w+%3D+p_we%5E%7Bt_w%7D)

![[公式]](https://www.zhihu.com/equation?tex=%5C%5Cb_h+%3D+p_he%5E%7Bt_h%7D)

其中 ![[公式]](https://www.zhihu.com/equation?tex=%28c_x%2C+x_y%29) 为cell的左上角坐标，如图5所示，在计算时每个cell的尺度为1，所以当前cell的左上角坐标为 ![[公式]](https://www.zhihu.com/equation?tex=%281%2C1%29) 。由于sigmoid函数的处理，边界框的中心位置会约束在当前cell内部，防止偏移过多。而 ![[公式]](https://www.zhihu.com/equation?tex=p_w) 和 ![[公式]](https://www.zhihu.com/equation?tex=p_h) 是先验框的宽度与长度，前面说过它们的值也是相对于特征图大小的，在特征图中每个cell的长和宽均为1。这里记特征图的大小为 ![[公式]](https://www.zhihu.com/equation?tex=%28W%2C+H%29) （在文中是 ![[公式]](https://www.zhihu.com/equation?tex=%2813%2C+13%29) )，这样我们可以将边界框相对于整张图片的位置和大小计算出来（4个值均在0和1之间）：

![[公式]](https://www.zhihu.com/equation?tex=%5C%5Cb_x+%3D+%28%5Csigma+%28t_x%29%2Bc_x%29%2FW)

![[公式]](https://www.zhihu.com/equation?tex=%5C%5C+b_y+%3D+%28%5Csigma+%28t_y%29+%2B+c_y%29%2FH)

![[公式]](https://www.zhihu.com/equation?tex=%5C%5Cb_w+%3D+p_we%5E%7Bt_w%7D%2FW)

![[公式]](https://www.zhihu.com/equation?tex=+%5C%5Cb_h+%3D+p_he%5E%7Bt_h%7D%2FH)

如果再将上面的4个值分别乘以图片的宽度和长度（像素点值）就可以得到边界框的最终位置和大小了。这就是YOLOv2边界框的整个解码过程。约束了边界框的位置预测值使得模型更容易稳定训练，结合聚类分析得到先验框与这种预测方法，YOLOv2的mAP值提升了约5%。

![img](https://pic3.zhimg.com/80/v2-7fee941c2e347efc2a3b19702a4acd8e_720w.jpg)

## Fine-Grained Features:

YOLOv2的输入图片大小为 ![[公式]](https://www.zhihu.com/equation?tex=416%5Ctimes416) ，经过5次maxpooling之后得到 ![[公式]](https://www.zhihu.com/equation?tex=13%5Ctimes13) 大小的特征图，并以此特征图采用卷积做预测。 ![[公式]](https://www.zhihu.com/equation?tex=13%5Ctimes13) 大小的特征图对检测大物体是足够了，但是对于小物体还需要更精细的特征图（Fine-Grained Features）。因此SSD使用了多尺度的特征图来分别检测不同大小的物体，前面更精细的特征图可以用来预测小物体。YOLOv2提出了一种passthrough层来利用更精细的特征图。YOLOv2所利用的Fine-Grained Features是 ![[公式]](https://www.zhihu.com/equation?tex=26%5Ctimes26) 大小的特征图（最后一个maxpooling层的输入），对于Darknet-19模型来说就是大小为 ![[公式]](https://www.zhihu.com/equation?tex=26%5Ctimes26%5Ctimes512) 的特征图。passthrough层与ResNet网络的shortcut类似，以前面更高分辨率的特征图为输入，然后将其连接到后面的低分辨率特征图上。前面的特征图维度是后面的特征图的2倍，passthrough层抽取前面层的每个 ![[公式]](https://www.zhihu.com/equation?tex=2%5Ctimes2) 的局部区域，然后将其转化为channel维度，对于 ![[公式]](https://www.zhihu.com/equation?tex=26%5Ctimes26%5Ctimes512) 的特征图，经passthrough层处理之后就变成了 ![[公式]](https://www.zhihu.com/equation?tex=13%5Ctimes13%5Ctimes2048) 的新特征图（特征图大小降低4倍，而channles增加4倍，图6为一个实例），这样就可以与后面的 ![[公式]](https://www.zhihu.com/equation?tex=13%5Ctimes13%5Ctimes1024) 特征图连接在一起形成 ![[公式]](https://www.zhihu.com/equation?tex=13%5Ctimes13%5Ctimes3072) 大小的特征图，然后在此特征图基础上卷积做预测。

![img](https://pic3.zhimg.com/80/v2-c94c787a81c1216d8963f7c173c6f086_720w.jpg)

作者在后期的实现中借鉴了ResNet网络，不是直接对高分辨特征图处理，而是增加了一个中间卷积层，先采用64个 ![[公式]](https://www.zhihu.com/equation?tex=1%5Ctimes1) 卷积核进行卷积，然后再进行passthrough处理，这样 ![[公式]](https://www.zhihu.com/equation?tex=26%5Ctimes26%5Ctimes512) 的特征图得到 ![[公式]](https://www.zhihu.com/equation?tex=13%5Ctimes13%5Ctimes256) 的特征图。这算是实现上的一个小细节。

在最后一个pooling之前，特征图的大小是26\*26\*512，将其1拆4,直接传递（passthrough）到pooling后（并且又经过一组卷积）的特征图，两者叠加到一起作为输出的特征图。

![img](https://pic2.zhimg.com/80/v2-8faf5d343e3a396d0751666833039eb1_720w.jpg)

## Multi-Scale Training 

由于YOLOv2模型中只有**卷积层和池化层**，所以YOLOv2的输入可以不限于 ![[公式]](https://www.zhihu.com/equation?tex=416%5Ctimes416) 大小的图片。

为了增强模型的鲁棒性，YOLOv2采用了多尺度输入训练策略，具体来说就是在训练过程中每间隔一定的iterations之后改变模型的输入图片大小。由于YOLOv2的下采样总步长为32，输入图片大小选择一系列为32倍数的值： ![[公式]](https://www.zhihu.com/equation?tex=%5C%7B320%2C+352%2C...%2C+608%5C%7D) ，输入图片最小为 ![[公式]](https://www.zhihu.com/equation?tex=320%5Ctimes320) ，此时对应的特征图大小为 ![[公式]](https://www.zhihu.com/equation?tex=10%5Ctimes10) ，而输入图片最大为 ![[公式]](https://www.zhihu.com/equation?tex=608%5Ctimes608) ，对应的特征图大小为 ![[公式]](https://www.zhihu.com/equation?tex=19%5Ctimes19) 。在训练过程，每隔10个iterations随机选择一种输入图片大小，然后只需要修改对最后检测层的处理就可以重新训练。

![preview](https://pic2.zhimg.com/v2-3c72c10c00c9268091d8c93f908d90ed_r.jpg)



YOLOv2的训练主要包括三个阶段。第一阶段就是先在ImageNet分类数据集上预训练Darknet-19，此时模型输入为 ![[公式]](https://www.zhihu.com/equation?tex=224%5Ctimes224) ，共训练160个epochs。然后第二阶段将网络的输入调整为 ![[公式]](https://www.zhihu.com/equation?tex=448%5Ctimes448) ，继续在ImageNet数据集上finetune分类模型，训练10个epochs，此时分类模型的top-1准确度为76.5%，而top-5准确度为93.3%。第三个阶段就是修改Darknet-19分类模型为检测模型，并在检测数据集上继续finetune网络。

网络修改包括：移除了最后一个卷积层，global avg pooling层以及softmax层，并且新增了三个3\*3\*2014卷积层，同时增加了一个passthrough层，最后使用1*1卷积层输出预测结果。输出的channels数为： ![[公式]](https://www.zhihu.com/equation?tex=%5Ctext%7Bnum_anchors%7D%5Ctimes%285%2B%5Ctext%7Bnum_classes%7D%29) ，和训练采用的数据集有关系。

## **YOLO2 输入->输出**

综上所述，虽然YOLO2做出了一些改进，但总的来说网络结构依然很简单，就是一些卷积+pooling，从416*416*3 变换到 13*13*5*25。稍微大一点的变化是增加了batch normalization，增加了一个passthrough层，去掉了全连接层，以及采用了5个先验框。

![img](https://pic2.zhimg.com/80/v2-50b64ae9c7687be4f5d96bac597ffabd_720w.jpg)

## **YOLO2 误差函数**

误差依然包括边框位置误差、置信度误差、对象分类误差。

![img](https://pic4.zhimg.com/80/v2-74511f262389468edd067b83d2dda637_720w.jpg)

![[公式]](https://www.zhihu.com/equation?tex=1_%7BMax+IOU%3CThresh%7D) 意思是预测边框中，与真实对象边框IOU最大的那个，其IOU<阈值Thresh，此系数为1，即计入误差，否则为0，不计入误差。YOLO2使用Thresh=0.6。

![[公式]](https://www.zhihu.com/equation?tex=1_%7Bt%3C128000%7D) 意思是前128000次迭代计入误差。注意这里是与先验框的误差，而不是与真实对象边框的误差。可能是为了在训练早期使模型更快学会先预测先验框的位置。

![[公式]](https://www.zhihu.com/equation?tex=1_%7Bk%7D%5E%7Btruth%7D) 意思是该边框负责预测一个真实对象（边框内有对象）。

各种 ![[公式]](https://www.zhihu.com/equation?tex=%5Clambda) 是不同类型误差的调节系数。

# YOLOv3

相比较YOLOv2,YOLOv3最大的变化包括2点：使用残差模型和采用FPN架构

## **新的网络结构Darknet-53**

在基本的图像特征提取方面，YOLO3采用了称之为Darknet-53的网络结构（含有53个卷积层），它借鉴了残差网络residual network的做法，在一些层之间设置了快捷链路（shortcut connections）。



![img](https://pic1.zhimg.com/80/v2-4d95ca9c05047f87787b966fa8673b98_720w.jpg)

上图的Darknet-53网络采用256*256*3作为输入，最左侧那一列的1、2、8等数字表示多少个重复的残差组件。每个残差组件有两个卷积层和一个快捷链路，示意图如下：



![img](https://pic2.zhimg.com/80/v2-efd4113a088031c17ec9b4ad66daea79_720w.jpg)图2 一个残差组件[2]

## **利用多尺度特征进行对象检测**

<img src="https://img-blog.csdn.net/2018100917221176?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xldmlvcGt1/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70" alt="img" style="zoom: 200%;" />

YOLO2曾采用passthrough结构来检测细粒度特征，在YOLO3更进一步采用了3个不同尺度的特征图来进行对象检测。

采用多尺度来对不同size的目标进行检测，越精细的grid cell就可以检测出越精细的物体。

concat：张量拼接。将darknet中间层和后面的某一层的上采样进行拼接。拼接的操作和残差层add的操作是不一样的，拼接会扩充张量的维度，而add只是直接相加不会导致张量维度的改变

比较大的特征图来检测相对较小的目标，而小的特征图负责检测大目标。

## **9种尺度的先验框**

随着输出的特征图的数量和尺度的变化，先验框的尺寸也需要相应的调整。YOLO2已经开始采用K-means聚类得到先验框的尺寸，YOLO3延续了这种方法，为每种下采样尺度设定3种先验框，总共聚类出9种尺寸的先验框。在COCO数据集这9个先验框是：(10x13)，(16x30)，(33x23)，(30x61)，(62x45)，(59x119)，(116x90)，(156x198)，(373x326)。

分配上，在最小的13*13特征图上（有最大的感受野）应用较大的先验框(116x90)，(156x198)，(373x326)，适合检测较大的对象。中等的26*26特征图上（中等感受野）应用中等的先验框(30x61)，(62x45)，(59x119)，适合检测中等大小的对象。较大的52*52特征图上（较小的感受野）应用较小的先验框(10x13)，(16x30)，(33x23)，适合检测较小的对象。



![img](https://pic1.zhimg.com/80/v2-35affdda3427ef1fadd0c9939e3de114_720w.jpg)

感受一下9种先验框的尺寸，下图中蓝色框为聚类得到的先验框。黄色框式ground truth，红框是对象中心点所在的网格。

![img](https://pic4.zhimg.com/80/v2-7d45deb4713deda091d336b1ef01878b_720w.jpg)

## **对象分类softmax改成logistic**

预测对象类别时不使用softmax，改成使用logistic的输出进行预测。这样能够支持多标签对象（比如一个人有Woman 和 Person两个标签）。

## **输入映射到输出**

![img](https://pic2.zhimg.com/80/v2-3728984de0737fb63b0632e583b24241_720w.jpg)

不考虑神经网络结构细节的话，总的来说，对于一个输入图像，YOLO3将其映射到3个尺度的输出张量，代表图像各个位置存在各种对象的概率。

我们看一下YOLO3共进行了多少个预测。对于一个416*416的输入图像，在每个尺度的特征图的每个网格设置3个先验框，总共有 13*13*3 + 26*26*3 + 52*52*3 = 10647 个预测。每一个预测是一个(4+1+80)=85维向量，这个85维向量包含边框坐标（4个数值），边框置信度（1个数值），对象类别的概率（对于COCO数据集，有80种对象）。

对比一下，YOLO2采用13*13*5 = 845个预测，YOLO3的尝试预测边框数量增加了10多倍，而且是在不同分辨率上进行，所以mAP以及对小物体的检测效果有一定的提升。