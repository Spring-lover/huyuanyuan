# KMP

## PMT

**部分匹配表**

PMT中的值是字符串的前缀集合与后缀集合的交集中最长元素的长度

例：主字符串“ababababca”中查找字符串“abababca”如果在j处字符不匹配。主字符串中i指针之前的PMT[j-1]为就一定与模式字符串的第0位至第PMT[j-1]位是相同的

![kmp1](/Users/hujiale/CodeNoteBook/Algorithm/kmp1.jpg)

如果是在j位失配，那么影响j指针回溯的位置的其实是第j-1位的PMT值，所以不会直接使用PMT数组而是将其后移一位，得到新的数组为next数组

## KMP算法

```c
int KMP(char * t, char * p){
    int i = 0;
    int j = 0;
    
    while(i < strlen(t) && j < strlen(p)){
        if(j == -1 || t[i] == p[j]){
            i ++;
            j ++;
        }else{
            j = next[j];
        }
    }
}
```

## next数组

求next数组的过程完全可以看成字符串匹配的过程，即以**模式字符串为主字符串，以模式字符串的前缀为目标字符串**，一旦字符串匹配成功，那么当前的next值就是匹配成功的字符串的长度

```c
void getNext(char * p, int * next){
    next[0] = -1;
    int i = 0, j = -1;
    while(i  < strlen(p)){
        if(j == -1 || p[i] == p[j]){
            ++i;
            ++j;
            next[i] = j;
        }else{
         	j = next[j];
        }
    }
}
```



