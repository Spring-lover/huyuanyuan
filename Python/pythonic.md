## 切片操作

```python
#  对原列表进行切割之后，会产生另外一份全新的列表，不会影响原列表
b = a[4:]
print('Before', b)
b[1] = 99
print('After', b)
print('No change', a)
```

## 对左侧进行切割赋值操作

```python
# 列表会根据新值的个数相应地扩张或收缩
# a = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h']
print('Before', a)
a[2:7] = [99, 22, 14]
print('After', a)

# Before ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h']
# After ['a', 'b', 99, 22, 14, 'h']
```

## enumerate

```python
flavor_list = ['vanilla', 'chocolate', 'pecan', 'strawberry']

for i, flavor in enumerate(flavor_list, 1):
    print('%.3f: %s' % (i+1, flavor))
    
2.000: vanilla
3.000: chocolate
4.000: pecan
5.000: strawberry
```

## zip

```python
# 将两个列表合成一个元组的生成器
names = ['Cecilia', 'Lisr', 'Marie']
letters = [len(n) for n in names]
max_letters = 0

for name, count in zip(names, letters):
    if count > max_letters:
        longest_name = name
        max_letters = count
    
print("longest_name is %s" % longest_name)
print("max_letters is %s" % max_letters)
```

## try/except/else/finally

```python
# try来读取文件并处理其内容
# except来应对try块中可能发生的相关异常
# else实时更新文件并把更新中可能出现的异常回报给上级代码
# finally来清理文件句柄
```

## 函数抛出异常而不是返回None

```python
def divide(a:int , b:int):
    try:
        return a/b
    except ZeroDivisionError as e: # 抛出异常让调用者去解决问题
        raise ValueError('Invalid inputs') from e

x, y = 5, 0
try:
    result = divide(x, y)
except ValueError: 
    print("Invalid Input")
else:
    print('Result is %.lf' % result)
```

## stack/queue

```python
stack = []
stack.append(1)
stack.pop(0)  #  代表着队列
stack.pop(-1)  #  代表着栈
```

## 获取闭包外的值

给变量赋值时，如果当前作用域内已经定义了这个变量，那么该变量就会具备新的值；若是当前作用域没有这个变量，Python则会把这次赋值视为对该变量的定义

```python
def sort_priority(values, group):
    Found = False

    def helper(x):
        nonlocal Found  # nonlocal代表着外作用域的Found的值
        if x in group:
            Found = True
            return (0, x)
        else:
            return (1, x)
    values.sort(key=helper)
    return Found


numbers = [8, 3, 1, 2, 5, 4, 7, 6]
group = {2, 3, 5, 7}

print(sort_priority(numbers, group))
```

## 通过列表获得（Python2）

```python
def sort_priority(values, group):
    Found = [False]

    def helper(x):
        if x in group:
            Found[0] = True
            return (0, x)
        else:
            return (1, x)
    values.sort(key=helper)
    return Found[0]


numbers = [8, 3, 1, 2, 5, 4, 7, 6]
group = {2, 3, 5, 7}

print(sort_priority(numbers, group))
```

## 通过编写辅助类Sorter

```python
class Sorter:
    def __init__(self, group):
        self._group = group
        self._found = False

    def __call__(self, x):
        if x in self._group:
            self._found = True
            return (0, x)
        else:
            return(1, x) 


numbers = [8, 3, 1, 2, 5, 4, 7, 6]
group = {2, 3, 5, 7}
sorter = Sorter(group)
numbers.sort(key=sorter1)

print(sorter._found)

```

## __iter__容器方法

```python
def normalize_defensive(numbers):
    if iter(numbers) is iter(numbers): # 判断是否是容器类型，iter每次调用返回不同的迭代器
        raise TypeError ('Must apply a container')
    total = sum(numbers)
    result = []
    for value in numbers:
        percent = 100 * value / total
        result.append(percent)
    return result
```

## 解决方法

```python
class ReadVisit(object):
    def __init__(self, data_path):
        self._data_path = data_path
        
    def __iter__(self):  #  重写__iter__方法
        with open(self._data_path) as f:
            for line in f:
                yield int(line)
```

## 使用None和文档字符串来描述具有动态默认值的参数

```python
import datetime
from time import sleep


def log(message, when = datetime.datetime.now()):
    # when = datetime.datetime.now() # 参数的默认值只会在程序加载模块并读到本函数的定义时评估一次
    print('%s %s' %(when, message))

log('Hi Here')
sleep(0.1)
log('Look Here')
```

## 只能用关键字来指定参数

```python
def safe_division_c(number, divisor, *, ignore_overflow=False, ignore_zero_division=False): # 写法
    try:
        return number/divisor
    except OverflowError:
        if ignore_overflow:
            return 0
        else:
            raise
    except ZeroDivisionError:
        if ignore_zero_division:
            return float('inf')
        else:
            raise

safe_division_c(1, 10**500, True, False)
```

## heapq

```python
import heapq

nums = [1, 8, 2, 23, 7, -4, 18, 23, 42, 37, 2] # 建立小顶堆
heap = list(nums)
heapq.heapify(heap)

print(heap[0])
heapq.heappop(heap)
print(heap[0])
```

## defaultdict

```python
from collections                   import defaultdict

d = defaultdict(list) #  创建列表
d['a'].append(1)
d['a'].append(2)
d['b'].append(3)

print(d)

s = defaultdict(set) # 创建集合

s['a'].add(1)
s['a'].add(2)
s['a'].add(2)
s['b'].add(3)

print(s)
```

## __repr__(self):

```python
class test(object):
    def __repr__(self): # 重新设置输出的对象的属性值
```

## OrderedDict

```python
from collections import OrderedDict 
import json

# 对于一个已经存在的键的重复赋值不会改变键的顺序
d = OrderedDict() # 大小是普通字典的2倍多，内部维护一个双向链表的原因
d['foo'] = 1
d['bar'] = 2
d['spam'] = 3
d['grok'] = 4

print(json.dumps(d)) # 转换为json数据格式
```

## sorted(zip(dict.values(), dict.keys()))

```python
prices = {
    'Python':45,
    'Java':32,
    'C++':30,
    'Ruby':23,
}
# 对字典的数据进行排序
prices_and_names = sorted(zip(prices.values(), prices.keys()))

print(max(prices_and_names)) # zip返回的迭代器只能做一次迭代运算
```

## 字典的key()和item()支持集合运算

```python
a = {
    'x':1, 
    'y':2,
    'z':3
}

b = {
    'w':10,
    'x':1,
    'y':2
}

c = {key : a[key] for key in a.keys() - {'z', 'w'}}

print(c)
```

## 对切片进行命名

```python
s = 'Helloworld'

a = slice(5, 10, 2) # 内置的slice对象

for i in range(*a.indices(len(s))):
    print(s[i])
```

## Counter记录出现次数最多的元素

```python
from collections import Counter

words = ['Python', 'Java', 'Java', 'Python', 'C++', 'Python']
word_counter = Counter(words) # 使用Counter进行计数

print(word_counter.most_common(2)) # most_common

word_update = ['Python', 'Java', 'Java', 'Java']
word_counter.update(word_update) # 使用update()对counter进行数据更新

print(word_counter)
```

## Hook函数使用

```python
from collections import defaultdict

class BetterCountMissing(object):
    def __init__(self):
        self._added = 0
    
    def __call__(self): # 重新__call__函数,使相关对象能够像函数那样得到调用
        self._added += 1
        return 0
    

counter = BetterCountMissing()

current = {'green':12, 'blue':3}
increments = [('red', 5), ('blue', 17), ('orange', 9)]

result = defaultdict(counter, current)
for key, amount in increments:
    result[key] += amount
    
print(result) 
print(counter._added) # counter._added = 2
```

## @classmethod

```python
class Data_test(object):
    def __init__(self, year=0, month=0, day=0):
        self.day = day
        self.month = month
        self.year = year

    def out_date(self):
        print("year :", self.year)
        print("month :", self.month)
        print("day :", self.day)


class Data_test2(object):
    def __init__(self, year=0, month=0, day=0):
        self.day = day
        self.month = month
        self.year = year

    @classmethod
    def get_date(cls, data_as_string):
        # 这里第一个参数是cls， 表示调用当前的类名
        year, month, day = map(int, data_as_string.split('-'))
        date1 = cls(year, month, day)
        # 返回的是一个初始化后的类
        return date1

    def out_date(self):
        print(self.year, self.month, self.day)


r = Data_test2.get_date("2016-8-6") # 不用实例化，直接调用
r.out_date()

# map(function, iterable) 返回一个迭代器
# split(str="", num=) str:分隔符 num:分割次数
```

## bisect.bisect_left(list, value)

```python
import bisect

L = [1, 3, 4, 6, 19]
x = 3
x_insert_point = bisect.bisect_left(L, x) # 1 >=
x_insert_point = bisect.bisect_right(L, x) # 2 >
```

## super多重继承

```python
class MyBaseClass(object):
    def __init__(self, value):
        self._value = value


class TimesFiveCorrect(MyBaseClass):
    def __init__(self, value):
        super().__init__(value)
        self._value *= 5


class PlusTwoCorrect(MyBaseClass):
    def __init__(self, value):
        super().__init__(value)
        self._value += 2
# 按照类继承的顺序进行初始化
class GoodWay(PlusTwoCorrect, TimesFiveCorrect):
    def __init__(self, value):
        super().__init__(value)
    

GW = GoodWay(5)
print(GW._value)
```

## __value

```python
# python 私有属性，__value 可以通过_Myclass__value获取到私有属性
class Myclass(object):
    def __init__(self, value):
        self.__value = value
    
foo = Myclass(5)
print(foo._Myclass__value) # 5
# 可以使用私有属性，防止子类的属性名与超类相冲突
```

## @property

```python
class Resistor(object):
    def __init__(self, ohms):
        self.ohms = ohms
        self.voltage = 0
        self.current = 0


class VoltageResistor(Resistor):
    def __init__(self, ohms):
        super().__init__(ohms)
        self._voltage = 0

    @property # get set 方法的名称必须与相关属性相符
    def voltage(self):
        return self._voltage
    
    @voltage.setter
    def voltage(self, voltage):
        self._voltage = voltage
        self.current = self._voltage / self.ohms
    
r2 = VoltageResistor(1e3)
print('Before: %5r amps ' % r2.current)
r2.voltage = 10
print('After: %5r amps '% r2.current)
# 考虑使用@property 代替属性重构
```

## 描述符代替@property

```python
class Grade(object):
    def __init__(self):
        self._value = 0
    def __get__(self, instance, instance_type):
        return self._value
    def __set__(self, instance, value):
        if not (0<= value <= 100):
            raise ValueError('Grade must be between 0 and 100')
        self._value = value

class Exam(object):
    math_grade = Grade()
    writing_grade = Grade()
    science_grade = Grade()

first_exam = Exam()
first_exam.writing_grade = 82
first_exam.science_grade = 99
print('Writing', first_exam.writing_grade)
print('Science', first_exam.science_grade)
# 所有Exam的实例都共享同一份Grade实例
second_exam = Exam()
second_exam.writing_grade = 75
print('Second', second_exam.writing_grade, 'is Wrong')
print('First', first_exam.writing_grade, 'is Right')
# 修改为

import weakref
class Grade(object):
    def __init__(self):
        self._value = weakref.WeakKeyDictionary() # 防止内存泄漏

    def __get__(self, instance, instance_type):
        if instance is None:
            return self
        return self._value.get(instance, 0)

    def __set__(self, instance, value):
        if not (0 <= value <= 100):
            raise ValueError('Grade must be between 0 and 100')
        self._value[instance] = value

class Exam(object):
    math_grade = Grade()
    writing_grade = Grade()
    science_grade = Grade()


first_exam = Exam()
first_exam.writing_grade = 82
first_exam.science_grade = 99
print('Writing', first_exam.writing_grade)
print('Science', first_exam.science_grade)

second_exam = Exam()
second_exam.writing_grade = 75
print('Second', second_exam.writing_grade, 'is Wrong')
print('First', first_exam.writing_grade, 'is Right')

```

## __getattr__

```python
class LazyDB(object):
    def __init__(self):
        self.exists = 5

    def __getattr__(self, name):
        '''
        动态获取属性值，如果没有name的属性就默认赋值
        '''
        value = 'Value for %s' % name
        setattr(self, name, value)
        return value


class LoggingLazyDB(LazyDB):
    def __getattr__(self, name):
        print('Called __getattr__(%s)' %name)
        return super().__getattr__(name) 


data = LoggingLazyDB()
print('Before: ', data.exists)
print('foo: ', data.foo)
print('After: ', data.foo)
```

## __getattribute__

```python
# __setattr__和__getattribute__：前者只会在待访问的属性缺失时触发，而后者则会在每次访问属性时触发
# 为了防止递归调用，使用super.__getattr__(name, va lue), super().__getattribute__(name, value)
```

## format

```python
print('value is {0}, {1}'.format('Python', 'Java'))
print('{}.format("hello", "world")')  # 不指定位置保证默认位置 
print('{:.2f}'.format(1.15))  # 保留两位小数
print('{:.0f}'.format(3.45))  # 四舍五入
print('{:0>2d}'.format(6))  # 不足的位左边补0
print('{:0<2d}'.format(6))  # 不足的位右边补0
# : 表示后面的需要特殊解释
# {!r} : 和format一起使用 
# %r: 直接反应对象的本体
```

Python 文件操作

```python
''' 文件操作
f = open(文件路径,mode="模式",encoding="编码")
  r:只读
  r+:可读可写,不会创建不存在的文件,从顶部开始写,会覆盖之前此位置的内容
  w+:可读可写,如果文件存在,则覆盖整个文件,不存在则创建
  w:只写,覆盖整个文件,不存在则创建
  a:追加写,不存在则创建
  a+:可读可写 从文件顶部读取内容 从文件底部添加内容 不存在则创建
  +:扩展
  b:字节(非文本文件)
'''
with open(filePath, 'r') as f:
    for line in f:
        line = line.strip()
```

## 列表推导

```python
# 生成4 * 4的二维列表
[[0] * 4 for _ in range(4)]
# 生成1维的数组
[0] * 4
# 对数组中的每一个元素进行计算
array = [1, 2, 3, 4, 5]
array = [x * 2 for x in array]
# [2, 4, 6, 8, 10]
```

## \

```python
# \ 代表着浮点数的相除
# \\ 代表着整数的相除
```

## 初始化二维数组

```python
dp = [[0] * columns for _ in range(rows)]
```

## hashable

1. 如果一个对象是可哈希的，则它是可被计算哈希值`__hash__()`
2. Python所有的内置不可变对象都是可哈希的
3. 列表，字典，集合是不可哈希的，因为在改变值的同时却没有改变内存id，无法由地址定位值的唯一性，因而不可哈希

## *

1. 表示乘号

2. 表示倍数

   ```python
   def T(msg, time=1):
     print((msg+' ')*time)
     
   T('hi', 3)
   
   >> hi hi hi
   ```

3. ```python
   a = [1, 2, 3, 4]
   print(*a)  # 将变量中可迭代对象的元素拆解出来，作为独立的参数传递给函数
   
   
   def demo(*num):  # 函数定义的时候使用，收集参数。将参数捕捉到一个元组中
       return num
   
   
   print(demo(1, 2, 3, 4))
   ```

   ```python
   def demo(**p):
     print(p)
     
   demo(x=1, y=2)
   
   >>> {'x': 1, 'y': 2} # 函数定义的时候使用，收集参数。将参数捕捉到一个字典中
   
   a = {'x': 1, 'y': 2}
   string = '{x}-{y}'.format(**a) # # 将变量中可迭代对象的元素拆解出来，作为独立的参数传递给函数
   ```

## any()

用于判断给定的可迭代参数iterable是否全部为False，则返回False，如果有一个为True则返回为True

## Unicode

能够使计算机实现跨语言、跨平台的文本转换及处理

## ord() chr()

```python
ord()  # 会以一个字符的参数,返回对应的ASCII数值
chr()  # ord()相反
```



