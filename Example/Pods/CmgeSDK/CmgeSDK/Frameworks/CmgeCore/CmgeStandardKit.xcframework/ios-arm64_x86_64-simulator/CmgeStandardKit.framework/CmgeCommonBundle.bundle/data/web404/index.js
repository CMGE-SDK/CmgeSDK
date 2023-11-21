var basic = {
    "method":"refreshWebView",
    "platform":"3",
    "content":null
}
var _startTime = (new Date()).getTime()
var u = navigator.userAgent;
var isAndroid = u.indexOf('Android') > -1 || u.indexOf('Adr') > -1; //android终端
var isiOS = !!u.match(/\(i[^;]+;( U;)? CPU.+Mac OS X/); //ios终端
// if (isAndroid) {
//   basic.platform = '1'
// }
// if (isiOS) {
//   basic.platform = '2'
// }
$('.wrap-close').click(function(){
  //关闭
  // bridge.call("webCallNativeAsyn",JSON.stringify({
  //   "method":"closeWebView",
  //   "platform":"3",
  //   "content":null
  // }),function (v) {
  //   console.log('获取基本参数')
  // })
  //点击刷新窗口-埋点
  // __Click('EV-CK-OTCE-02')
  //点击刷新窗口-UI页面曝光
  // __UI('UI-OTCE',_startTime,(new Date()).getTime())
  bridge.call("webCallNativeSyn",JSON.stringify({
    "method":"closeWebView",
    "platform":"3",
    "content":null
  }),function (v) {
    console.log('获取基本参数')
  })
})
$(".btn-refresh").click(function () {
  //刷新
  // bridge.call("webCallNativeAsyn",JSON.stringify(basic),function (v) {
  //   console.log('获取基本参数')
  // })
  //点击刷新窗口-埋点
  // __Click('EV-CK-OTCE-01')
  //点击刷新窗口-UI页面曝光
  // __UI('UI-OTCE',_startTime,(new Date()).getTime())
  bridge.call("webCallNativeSyn",JSON.stringify(basic))
})
