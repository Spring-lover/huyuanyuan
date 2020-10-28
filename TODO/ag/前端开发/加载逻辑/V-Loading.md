## v-loading

```javascript
FilePath: 
  ag-client/src/components/Risk/Common/RiskNsrHeader.vue
  ag-client/src/components/Risk/RiskNsrContent/RiskContentItem/RNCrossNsr.vue

// 非table的元素
data(){
  return {
    contentLoading: null
  }
},
  
showLoading() {
  this.hideLoading()
  this.contentLoading = this.$loading({
    target: document.querySelector('#risk-nsr-info-container'), // 选择对应需要loading样式的div
    background: 'rgba(0, 0, 0, 0.8)',
    lock: true
  })
},
hideLoading() {
  if (this.contentLoading) {
    this.contentLoading.close() // 放在请求异步数据之后的finally中
  }
},
checkIfEndingLoading() {
  const checkLoading = setInterval(() => {
    if (this.infod !== null) { // 这里判断需要看对应的数据是否异步获取到了 再hide loading样式
      this.hideLoading()
      clearInterval(checkLoading)
    }
  }, 1000)
}

// table元素
<el-table
  v-loading="loading"
  v-loading.lock="true"
>
</el-table>

data(){
  return {
    loading: true
  }
}

queryRiskCrossInfoTable() {
  DataApi.nsrriskcrossinfodiscovery_table({nsrsbh: this.info, year: this.year}).then(data => {
    this.tableData = data
  }).finally(() => {
    this.loading = false // 正常或异常响应均设置loading false
  })

}
```