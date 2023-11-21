// var vConsole = new VConsole()
if(window.location.href.indexOf('cdnh5page.cmge.com/gray')!=-1 || window.location.href.indexOf('testh5page.cmge.com')!=-1){
  var vConsole = new VConsole()
}
// 基本参数 common
var CONFIGS = {
    avoid: {
      name: {
        value: '请输入姓名',
        rule: /^[\u4E00-\u9FA5]{2,4}$/,
        fomat: '请输入正确姓名'
      },
      idCard: {
        value: '请输入身份证号码',
        rule: /(^\d{15}$)|(^\d{18}$)|(^\d{17}(\d|X|x)$)/,
        fomat: '请输入正确身份证号码'
      }
    }
  }
var basic = {
    "method":"getSDKInfo",
    "platform":"2"
}
function getContentData () {
  bridge.call("webCallNativeAsyn",JSON.stringify(basic),function (v) {
    console.log('获取基本参数')
    console.log(JSON.parse(v))
    return JSON.parse(v).contentData
  })
}

//点击事件-埋点
function __Click(__eventName){
  bridge.call("webCallNativeSyn",JSON.stringify({method:"dataTrack",platform:"3","content":{
    dataType:1,
    subType:'Click',
    eventName:__eventName
  }}))
}

//支付事件-埋点
function __Pay(__zfId,__zfMn){
  bridge.call("webCallNativeSyn",JSON.stringify({method:"dataTrack",platform:"3","content":{
    dataType:1,
    subType:'ZF',
    zfId:__zfId,
    zfMn:__zfMn
  }}))
}

//UI页面曝光-埋点
function __UI(__timeConsumeName,__startTime,__endTime){
  bridge.call("webCallNativeSyn",JSON.stringify({method:"dataTrack",platform:"3","content":{
    dataType:2,
    timeConsumeName:__timeConsumeName,
    startTime:__startTime,
    endTime:__endTime
  }}))
}

//刷新页面-页面曝光
var __currentTimeConsumeName = ''
function __refresh(__timeConsumeName,__startTime){
  __currentTimeConsumeName = __timeConsumeName
  sessionStorage.setItem('__time',(new Date()).getTime());
  // if(sessionStorage.getItem('__time')){
  //   //如果存储了页面时间戳，则表示要刷新页面了
  //   sessionStorage.setItem('__time',(new Date()).getTime());
  // }else{
  //   //如果没有存储页面时间戳，则是刚进来页面
  //   sessionStorage.setItem('__time',(new Date().getTime()))
  // }  
}

// window.addEventListener("beforeunload", function (e) {
//   //不是所有浏览器都支持提示信息的修改
//   // var confirmationMessage = "请先保存您编辑的内容,否则您修改的信息会丢失。";
//   // e.returnValue = confirmationMessage;
//   __UI(__currentTimeConsumeName,sessionStorage.getItem('__time'));//离开页面触发数据上报
//   // sessionStorage.setItem('__time','');//离开页面的时候清空页面时间戳，保证下次进来能准确判断是否刷新页面
//   // return confirmationMessage;
// });
// window.addEventListener("pagehide", function (e) {
//   if(__currentTimeConsumeName){
//     __UI(__currentTimeConsumeName,sessionStorage.getItem('__time'),(new Date()).getTime());//离开页面触发数据上报
//   }
//   // sessionStorage.setItem('__time','');//离开页面的时候清空页面时间戳，保证下次进来能准确判断是否刷新页面
// });

function closeH5 () {
  // bridge.call("webCallNativeAsyn",JSON.stringify({method:"closeWebView",platform:"3"}),function (v) {
  //   console.log('关闭h5')
  //   console.log(v)
  // })
  dsBridge.call(
    "webCallNativeSyn",
    JSON.stringify({method:"closeWebView",platform:"3"})
  );
  console.log('关闭h5')
  console.log(v)
}
// 完成实名制
function finished () {
  // dsBridge.call("webCallNativeAsyn",JSON.stringify({method:"realNameAuthComplete",platform:"3"}), function (v) { 
  //   console.log('完成实名制')
  //   console.log(v)
  // })
  dsBridge.call(
    "webCallNativeSyn",
    JSON.stringify({method:"realNameAuthComplete",platform:"3"})
  );
}



function price(a){
  var num = Number(a);
  if(!num){//等于0
      return num+'.00'
  }else{//不等于0
      num = Math.round((num)*100)/10000
      num = num.toFixed(2)
      num+=''//转成字符串
      var reg=num.indexOf('.') >-1 ? /(\d{1,3})(?=(?:\d{3})+\.)/g : /(\d{1,3})(?=(?:\d{3})+$)/g // 千分符的正则
      return num.replace(reg, '$1,') // 千分位格式化
  }
}
function popup (msg) {
  $(".popup-msg").html(msg)
  $(".popup").show()
  setTimeout(function () {
    $(".popup").hide()
  }, 3000)
}

function check (data, type) {
  for (var key in data) {
    if (data[key] === '') {
      popup(CONFIGS[type][key]['value'])
      return false
    }
    if (CONFIGS[type][key]['rule'] !== '') {
      if(!CONFIGS[type][key]['rule'].test(data[key])) {
        popup(CONFIGS[type][key]['fomat'])
        return false
      }
    }
  }
  return true
}

// 获取生日
function getAge(strBirthday){       
  var returnAge,
    strBirthdayArr=strBirthday.split("-"),
    birthYear = strBirthdayArr[0],
    birthMonth = strBirthdayArr[1],
    birthDay = strBirthdayArr[2],  
      d = new Date(),
    nowYear = d.getFullYear(),
    nowMonth = d.getMonth() + 1,
    nowDay = d.getDate();   
  if(nowYear == birthYear){
      returnAge = 0;//同年 则为0周岁
  }
  else{
      var ageDiff = nowYear - birthYear ; //年之差
      if(ageDiff > 0){
          if(nowMonth == birthMonth) {
              var dayDiff = nowDay - birthDay;//日之差
              if(dayDiff < 0) {
                  returnAge = ageDiff - 1;
              }else {
                  returnAge = ageDiff;
              }
          }else {
              var monthDiff = nowMonth - birthMonth;//月之差
              if(monthDiff < 0) {
                  returnAge = ageDiff - 1;
              }
              else {
                  returnAge = ageDiff ;
              }
          }
      }else {
          returnAge = -1;//返回-1 表示出生日期输入错误 晚于今天
      }
  } 
  return returnAge;//返回周岁年龄
}