## 测试数据生成脚本

测试数据存储位置为`csvs/enhanced-data/`

生成数据存储位置为`test/5TIMES`和`test/10TIMES`-


```python
import csv
import os

# 将nsrsbh和nsrmc末尾加上II-X的后缀

name = ['', 'II', 'III', 'IV', 'V', 'VI', 'VII', 'VIII', 'IX', 'X']

for j in range(5, 11, 5):
    for filename in os.listdir(r'./csvs/enhanced-data'):
        r = open('csvs/enhanced-data/' + filename, 'r')
        enhanceType = filename[:filename.index('.')]
        w = open('./test/' + str(j) + 'TIMES/' + enhanceType + 'Enhanced' + str(j) + 'Times.csv', 'w', newline='')
        read = csv.reader(r)
        write = csv.writer(w, delimiter='\t')
        for i, line in enumerate(read):
            enhanceLine = line[0].split('\t')
            if i == 0:
                write.writerow(enhanceLine)
                continue
            for appendedName in name[: j]:
                enhanceLine = line[0].split('\t')
                enhanceLine[0] += appendedName
                enhanceLine[1] += appendedName
                write.writerow(enhanceLine)
        r.close()
        w.close()
```