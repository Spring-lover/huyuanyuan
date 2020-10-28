## LazyLoading

```javascript
FilePath: 
  ag-client/src/components/Risk/RiskNsrContent/RiskNsrContent.vue 父组件
  ag-client/src/components/Risk/RiskNsrContent/RiskContentItem/RNGraphLink.vue 子组件

// 父组件
this.SQGraphLink = true
const riskGraphLink = document.getElementById('risk-graph-link') // 获取到dom元素
this.riskGraphLinkBoundingClientRect = riskGraphLink.getBoundingClientRect().top // 获取该div到页面顶部的距离

// 通过监听滚动事件来位置来传递是否查询的参数
onScroll() {
  // 防止多次查询
  if (this.getViewHeight() > this.riskGraphLinkBoundingClientRect && this.SQGraphLink === false) {
    this.SQGraphLink = true
  }
}

// 子元素监听父组件传递的参数
watch: {
  isQuery(newValue, oldValue) {
    if (newValue === true) {
      this.queryNsrRiskLinkAbnormalData() // 对应的查询函数
    }
  }
}

// 给对应的查询按钮添加防抖函数，避免多次发送请求
this.throttleQueryFunc = _throttle(() => _.queryNsrRiskLinkAbnormalData(), 1000)
queryFunc() {
  this.throttleQueryFunc()
}
```