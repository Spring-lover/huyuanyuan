###  获取预处理程序的时间戳
```javascript
const state = {
  maxDataTime: {
    YEAR: '',
    MONTH: '',
    YEARMONTH: ''
  }
}
```

###  改变时间硬编码 将统一时间戳存入state中

```javascript
console.log('after permission get Time' + store.getters.year)
console.log('after permission get TimeYear ' + store.getters.yearMonth)
console.log('after permission get TimeMonth ' + store.getters.month)
```