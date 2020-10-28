# 全连接层：

就是它把特征`representation`整合到一起，输出一个值，**大大减少特征位置对分类带来的影响。**

例如：最后一层卷积层输出为7\*7\*512,后一层含有4096个神经元的`FC`，则可用卷积核为7\*7\*512\*4096的全局卷积来实现这一个全连接的过程。

我们用许多神经元去拟合数据分布

但是只用一层`fully connected layer`有时候没法解决非线性问题

**而如果有两层或以上fully connected layer就可以很好地解决非线性问题了**

# 残差网络

网络的精度会随着网络的层数增多而增多嘛？

- 计算资源的消耗
- 模型容易过拟合
- 梯度消失/梯度爆炸问题 

如果一个VGG-100网络在第98层使用的是和VGG-16第14层一模一样的特征，那么VGG-100的效果应该会和VGG-16的效果相同。所以，我们可以在VGG-100的98层和14层之间添加一条**直接映射**`（Identity Mapping）`来达到此效果。

在卷积网络中， ![[公式]](https://www.zhihu.com/equation?tex=x_l) 可能和 ![[公式]](https://www.zhihu.com/equation?tex=x_%7Bl%2B1%7D) 的Feature Map的数量不一样，这时候就需要使用 ![[公式]](https://www.zhihu.com/equation?tex=1%5Ctimes1) 卷积进行升维或者降维（图2）。这时，残差块表示为：

![[公式]](https://www.zhihu.com/equation?tex=x_%7Bl%2B1%7D%3D+h%28x_l%29%2B%5Cmathcal%7BF%7D%28x_l%2C+%7BW_l%7D%29%5Ctag%7B2%7D)

其中 ![[公式]](https://www.zhihu.com/equation?tex=h%28x_l%29+%3D+W%27_lx) 。其中 ![[公式]](https://www.zhihu.com/equation?tex=W%27_l) 是 ![[公式]](https://www.zhihu.com/equation?tex=1%5Ctimes1) 卷积操作，但是实验结果 ![[公式]](https://www.zhihu.com/equation?tex=1%5Ctimes1) 卷积对模型性能提升有限，所以一般是在升维或者降维时才会使用。

![img](https://pic3.zhimg.com/80/v2-54d11fdb5da318615fae5f579f68c31a_720w.jpg)

残差块一个更通用的表示方式是

![[公式]](https://www.zhihu.com/equation?tex=y_l%3D+h%28x_l%29%2B%5Cmathcal%7BF%7D%28x_l%2C+%7BW_l%7D%29%5Ctag%7B3%7D)

![[公式]](https://www.zhihu.com/equation?tex=x_%7Bl%2B1%7D+%3D+f%28y_l%29%5Ctag%7B4%7D)

那么这时候残差块可以表示为：

![[公式]](https://www.zhihu.com/equation?tex=x_%7Bl%2B1%7D+%3D+x_l+%2B+%5Cmathcal%7BF%7D%28x_l%2C+%7BW_l%7D%29%5Ctag%7B5%7D)

对于一个更深的层 ![[公式]](https://www.zhihu.com/equation?tex=L) ，其与 ![[公式]](https://www.zhihu.com/equation?tex=l) 层的关系可以表示为

![[公式]](https://www.zhihu.com/equation?tex=x_L+%3D+x_l+%2B+%5Csum_%7Bi%3D1%7D%5E%7BL-1%7D%5Cmathcal%7BF%7D%28x_i%2C+%7BW_i%7D%29%5Ctag%7B6%7D)

这个公式反应了残差网络的两个属性：

1. ![[公式]](https://www.zhihu.com/equation?tex=L) 层可以表示为任意一个比它浅的l层和他们之间的残差部分之和；

2. ![[公式]](https://www.zhihu.com/equation?tex=x_L%3D+x_0+%2B+%5Csum_%7Bi%3D0%7D%5E%7BL-1%7D%5Cmathcal%7BF%7D%28x_i%2C+%7BW_i%7D%29) ， ![[公式]](https://www.zhihu.com/equation?tex=L) 是各个残差块特征的单位累和，而MLP是特征矩阵的累积。

   **上面公式反映了残差网络的两个属性：**

1. 在整个训练过程中， ![[公式]](https://www.zhihu.com/equation?tex=%5Cfrac%7B%5Cpartial+%7D%7B%5Cpartial+x_l%7D%5Csum_%7Bi%3D1%7D%5E%7BL-1%7D%5Cmathcal%7BF%7D%28x_i%2C+%7BW_i%7D%29+) 不可能一直为 ![[公式]](https://www.zhihu.com/equation?tex=-1) ，也就是说在残差网络中不会出现梯度消失的问题。
2. ![[公式]](https://www.zhihu.com/equation?tex=%5Cfrac%7B%5Cpartial+%5Cvarepsilon%7D%7B%5Cpartial+x_L%7D) 表示 ![[公式]](https://www.zhihu.com/equation?tex=L) 层的梯度可以直接传递到任何一个比它浅的 ![[公式]](https://www.zhihu.com/equation?tex=l) 层。

# Anchor Box

## Regional Proposal

这是R-CNN系列中核心的思想，以Faster R-CNN为例，模型中使用了两个神经网络，一个是是CNN，一个是`RPN(Regional Proposal)`，区域建议网络不负责图像的分类，它只负责选取出图像中可能属于数据集其中一类的候选区域。接下来就是把RPN产生的候选区域输入到分类网络中进行最终的分类。

## anchor box

### 原因： 

- 一个窗口只能检测一个目标
- 无法解决多尺度问题

### 为什么使用不同尺寸和不同长宽比？

对于计算机视觉，比较容易理解的是真实标签(ground truth)，人为为每个目标标记的标签。但是在加入anchor box思想之后，在训练集中，我们将每个锚框视为一个训练样本。因此，为了训练目标模型，需要标记每个anchor box的标签，这里的标签包括两个部分：

- 类别标签
- 偏移量

有多个anchor box，到底该选取哪一个呢？这是就要通过交并比进行选择。试想一下，如果用一个固定尺寸的anchor，那么对于anchor的标记就没有了针对性。

![img](https://pic1.zhimg.com/80/v2-c7475c1771b2ebbfd127f8a0c1ff6598_720w.jpg)

举例说明一下，图中棕色的为行人的真实标签，黄色的为车辆的真实标签，红色的框是从feature map映射的anchor box，这样的话通过交并比就很难获取feature map中每个单元对应的标签。

![img](https://pic3.zhimg.com/80/v2-f6850f79fddac6fab20c7c66dce21bc2_720w.jpg)

![img](https://pic1.zhimg.com/80/v2-15cce6699bd481b66128a2d63c026600_720w.jpg)

这样的话，可以用anchor box1与行人的交并比比较大，可以用于训练和预测行人，anchor box 2与汽车的交并比较大，可以用于训练和预测汽车。使用不同长宽比和尺寸的anchor box，这样更加具有针对性。

### anchor box的尺寸怎么选择？

目前anchor box的选择主要有三种方式：

- 人为经验选取
- k-means聚类
- 作为超参数进行学习

## 训练阶段

### 标注

在训练阶段，是把anchor box作为训练样本，为了训练样本我们需要为每个锚框标注两类标签：一是锚框所含目标的类别，简称**类别**；二是真实边界框相对锚框的偏移量，简称**偏移量**（offset）。在目标检测时，我们首先生成多个锚框，然后为每个锚框预测类别以及偏移量，接着根据预测的偏移量调整锚框位置从而得到预测边界框，最后筛选需要输出的预测边界框。

已经知道每个目标的ground-truth，怎么标注anchor-box的标签：使用**最大交并比**

假设图像中有 ![[公式]](https://www.zhihu.com/equation?tex=n_a) 个anchor box，有 ![[公式]](https://www.zhihu.com/equation?tex=n_b) 个真实边界框，这样的话就形成了一个anchor box与真实边界框之间的对应关系矩阵 ![[公式]](https://www.zhihu.com/equation?tex=X%5Cin+R%5E%7Bn_a%5Ctimes+n_b%7D) ，那么就根据这个对应关系找出与每个anchor box交并比最大的真实边界框，然后真实边界框的标签作为anchor box的标签，然后计算anchor box相对于真实边界框的偏移量。

### 训练：

**训练阶段在什么时候触发anchor box?**

![img](https://pic4.zhimg.com/80/v2-3047e61d1484564f2e2d84bb8da0249b_720w.jpg)

在经过一系列卷积和池化之后，在feature map层使用anchor box，如上图所示，经过一系列的特征提取，最后针对 ![[公式]](https://www.zhihu.com/equation?tex=3%5Ctimes3) 的网格会得到一个 ![[公式]](https://www.zhihu.com/equation?tex=3%5Ctimes3%5Ctimes2%5Ctimes8) 的特征层，其中2是anchor box的个数，以《deep learning》课程为例选择两个anchor box，8代表每个anchor box包含的变量数，分别是4个位置偏移量、3个类别(one-hot标注方式)、1个anchor box标注(如果anchor box与真实边框的交并比最大则为1，否则为0)。

到了特征层之后对每个cell映射到原图中，找到预先标注的anchor box，然后计算这个anchor box与ground truth之间的损失，训练的主要目的就是训练出用anchor box去拟合真实边框的模型参数。

## 预测阶段：

首先在图像中生成多个anchor box，然后根据训练好的模型参数去预测这些anchor box的类别和偏移量，进而得到预测的边界框。由于阈值和anchor box数量选择的问题，同一个目标可能会输出多个相似的预测边界框，这样不仅不简洁，而且会增加计算量，为了解决这个问题，常用的措施是使用非极大值抑制(non-maximum suppression，NMS)。

对于一个预测边界框 ![[公式]](https://www.zhihu.com/equation?tex=B) ，模型最终会输出会计算它属于每个类别的概率值，其中概率值最大对应的类别就是预测边界框的类别。在同一副图像上，把所有预测边界框(不区分类别)的预测概率从大到小进行排列，然后取出最大概率的预测边界框 ![[公式]](https://www.zhihu.com/equation?tex=B_1) 作为基准，然后计算剩余的预测边界框与 ![[公式]](https://www.zhihu.com/equation?tex=B_1) 的交并比，如果大于给定的某个阈值，则将这个预测边界框移除。这样的话保留了概率最大的预测边界框并移除了其他与其相似的边界框。接下来要做的就是从剩余的预测边界框中选出概率值最大的预测边界框 ![[公式]](https://www.zhihu.com/equation?tex=B_2) 计算过程重复上述的过程。

## 什么是Internal Covariate Shift

下图是一个多层的神经网络，层与层之间采用全连接的方式进行连接。

![img](https://pic4.zhimg.com/80/v2-c3934c77a543b6c588af07a365f9a70b_720w.jpg)



我们规定左侧为神经网络的底层，右侧为神经网络的上层。那么网络中层与层之间的关联性会导致如下的状况：随着训练的进行，网络中的参数也随着梯度下降在不停更新。一方面，当底层网络中参数发生微弱变化时，由于每一层中的线性变换与非线性激活映射，这些微弱变化随着网络层数的加深而被放大（类似蝴蝶效应）；另一方面，参数的变化导致每一层的输入分布会发生改变，进而上层的网络需要不停地去适应这些分布变化，使得我们的模型训练变得困难。上述这一现象叫做Internal Covariate Shift。

## 我们如何减缓Internal Covariate Shift?

### （1）白化（Whitening）

白化是机器学习里面常用的一种规范化数据分布的方法，主要是PCA白化与ZCA白化。白化是对输入数据分布进行变换。

- **使得输入特征分布具有相同的均值与方差。**其中PCA白化保证了所有特征分布均值为0，方差为1；而ZCA白化则保证了所有特征分布均值为0，方差相同；
- **去除特征之间的相关性。**

### **（2）Batch Normalization提出**

既然白化可以解决这个问题，为什么我们还要提出别的解决办法？当然是现有的方法具有一定的缺陷，白化主要有以下两个问题：

- **白化过程计算成本太高，**并且在每一轮训练中的每一层我们都需要做如此高成本计算的白化操作；
- **白化过程由于改变了网络每一层的分布**，因而改变了网络层中本身数据的表达能力。底层网络学习到的参数信息会被白化操作丢失掉。

例：

![img](https://pic1.zhimg.com/80/v2-084e9875d10896369e09af5a60e56250_720w.jpg)

对于第一个神经元，我们求得 ![[公式]](https://www.zhihu.com/equation?tex=%5Cmu_1%3D1.65) ， ![[公式]](https://www.zhihu.com/equation?tex=%5Csigma%5E2_1%3D0.44) （其中 ![[公式]](https://www.zhihu.com/equation?tex=%5Cepsilon%3D10%5E%7B-8%7D) ），此时我们利用 ![[公式]](https://www.zhihu.com/equation?tex=%5Cmu_1%2C%5Csigma%5E2_1) 对第一行数据（第一个维度）进行normalization得到新的值 ![[公式]](https://www.zhihu.com/equation?tex=%5B-0.98%2C-0.23%2C-0.68%2C-1.13%2C0.08%2C0.68%2C2.19%2C0.08%5D) 。同理我们可以计算出其他输入维度归一化后的值。如下图：

![preview](https://pic3.zhimg.com/v2-c37bda8f138402cc7c3dd62c509d36f6_r.jpg)

通过上面的变换，**我们解决了第一个问题，即用更加简化的方式来对数据进行规范化，使得第 ![[公式]](https://www.zhihu.com/equation?tex=l) 层的输入每个特征的分布均值为0，方差为1。**

如同上面提到的，Normalization操作我们虽然缓解了ICS问题，让每一层网络的输入数据分布都变得稳定，但却导致了数据表达能力的缺失。也就是我们通过变换操作改变了原有数据的信息表达（representation ability of the network），使得底层网络学习到的参数信息丢失。另一方面，通过让每一层的输入分布均值为0，方差为1，会使得输入在经过sigmoid或tanh激活函数时，容易陷入非线性激活函数的线性区域。

因此，BN又引入了两个可学习（learnable）的参数 ![[公式]](https://www.zhihu.com/equation?tex=%5Cgamma) 与 ![[公式]](https://www.zhihu.com/equation?tex=%5Cbeta) 。这两个参数的引入是为了恢复数据本身的表达能力，对规范化后的数据进行线性变换，即 ![[公式]](https://www.zhihu.com/equation?tex=%5Ctilde%7BZ_j%7D%3D%5Cgamma_j+%5Chat%7BZ%7D_j%2B%5Cbeta_j) 。特别地，当 ![[公式]](https://www.zhihu.com/equation?tex=%5Cgamma%5E2%3D%5Csigma%5E2%2C%5Cbeta%3D%5Cmu) 时，可以实现等价变换（identity transform）并且保留了原始输入特征的分布信息。