/*!    SWFObject v2.3.20130521 <http://github.com/swfobject/swfobject>
 is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
 */
var swfobject=function(){var D="undefined",r="object",T="Shockwave Flash",Z="ShockwaveFlash.ShockwaveFlash",q="application/x-shockwave-flash",S="SWFObjectExprInst",x="onreadystatechange",Q=window,h=document,t=navigator,V=false,X=[],o=[],P=[],K=[],I,p,E,B,L=false,a=false,m,G,j=true,l=false,O=function(){var ad=typeof h.getElementById!=D&&typeof h.getElementsByTagName!=D&&typeof h.createElement!=D,ak=t.userAgent.toLowerCase(),ab=t.platform.toLowerCase(),ah=ab?/win/.test(ab):/win/.test(ak),af=ab?/mac/.test(ab):/mac/.test(ak),ai=/webkit/.test(ak)?parseFloat(ak.replace(/^.*webkit\/(\d+(\.\d+)?).*$/,"$1")):false,aa=t.appName==="Microsoft Internet Explorer",aj=[0,0,0],ae=null;if(typeof t.plugins!=D&&typeof t.plugins[T]==r){ae=t.plugins[T].description;if(ae&&(typeof t.mimeTypes!=D&&t.mimeTypes[q]&&t.mimeTypes[q].enabledPlugin)){V=true;aa=false;ae=ae.replace(/^.*\s+(\S+\s+\S+$)/,"$1");aj[0]=n(ae.replace(/^(.*)\..*$/,"$1"));aj[1]=n(ae.replace(/^.*\.(.*)\s.*$/,"$1"));aj[2]=/[a-zA-Z]/.test(ae)?n(ae.replace(/^.*[a-zA-Z]+(.*)$/,"$1")):0}}else{if(typeof Q.ActiveXObject!=D){try{var ag=new ActiveXObject(Z);if(ag){ae=ag.GetVariable("$version");if(ae){aa=true;ae=ae.split(" ")[1].split(",");aj=[n(ae[0]),n(ae[1]),n(ae[2])]}}}catch(ac){}}}return{w3:ad,pv:aj,wk:ai,ie:aa,win:ah,mac:af}}(),i=function(){if(!O.w3){return}if((typeof h.readyState!=D&&(h.readyState==="complete"||h.readyState==="interactive"))||(typeof h.readyState==D&&(h.getElementsByTagName("body")[0]||h.body))){f()}if(!L){if(typeof h.addEventListener!=D){h.addEventListener("DOMContentLoaded",f,false)}if(O.ie){h.attachEvent(x,function aa(){if(h.readyState=="complete"){h.detachEvent(x,aa);f()}});if(Q==top){(function ac(){if(L){return}try{h.documentElement.doScroll("left")}catch(ad){setTimeout(ac,0);return}f()}())}}if(O.wk){(function ab(){if(L){return}if(!/loaded|complete/.test(h.readyState)){setTimeout(ab,0);return}f()}())}}}();function f(){if(L||!document.getElementsByTagName("body")[0]){return}try{var ac,ad=C("span");ad.style.display="none";ac=h.getElementsByTagName("body")[0].appendChild(ad);ac.parentNode.removeChild(ac);ac=null;ad=null}catch(ae){return}L=true;var aa=X.length;for(var ab=0;ab<aa;ab++){X[ab]()}}function M(aa){if(L){aa()}else{X[X.length]=aa}}function s(ab){if(typeof Q.addEventListener!=D){Q.addEventListener("load",ab,false)}else{if(typeof h.addEventListener!=D){h.addEventListener("load",ab,false)}else{if(typeof Q.attachEvent!=D){g(Q,"onload",ab)}else{if(typeof Q.onload=="function"){var aa=Q.onload;Q.onload=function(){aa();ab()}}else{Q.onload=ab}}}}}function Y(){var aa=h.getElementsByTagName("body")[0];var ae=C(r);ae.setAttribute("style","visibility: hidden;");ae.setAttribute("type",q);var ad=aa.appendChild(ae);if(ad){var ac=0;(function ab(){if(typeof ad.GetVariable!=D){try{var ag=ad.GetVariable("$version");if(ag){ag=ag.split(" ")[1].split(",");O.pv=[n(ag[0]),n(ag[1]),n(ag[2])]}}catch(af){O.pv=[8,0,0]}}else{if(ac<10){ac++;setTimeout(ab,10);return}}aa.removeChild(ae);ad=null;H()}())}else{H()}}function H(){var aj=o.length;if(aj>0){for(var ai=0;ai<aj;ai++){var ab=o[ai].id;var ae=o[ai].callbackFn;var ad={success:false,id:ab};if(O.pv[0]>0){var ah=c(ab);if(ah){if(F(o[ai].swfVersion)&&!(O.wk&&O.wk<312)){w(ab,true);if(ae){ad.success=true;ad.ref=z(ab);ad.id=ab;ae(ad)}}else{if(o[ai].expressInstall&&A()){var al={};al.data=o[ai].expressInstall;al.width=ah.getAttribute("width")||"0";al.height=ah.getAttribute("height")||"0";if(ah.getAttribute("class")){al.styleclass=ah.getAttribute("class")}if(ah.getAttribute("align")){al.align=ah.getAttribute("align")}var ak={};var aa=ah.getElementsByTagName("param");var af=aa.length;for(var ag=0;ag<af;ag++){if(aa[ag].getAttribute("name").toLowerCase()!="movie"){ak[aa[ag].getAttribute("name")]=aa[ag].getAttribute("value")}}R(al,ak,ab,ae)}else{b(ah);if(ae){ae(ad)}}}}}else{w(ab,true);if(ae){var ac=z(ab);if(ac&&typeof ac.SetVariable!=D){ad.success=true;ad.ref=ac;ad.id=ac.id}ae(ad)}}}}}X[0]=function(){if(V){Y()}else{H()}};function z(ac){var aa=null,ab=c(ac);if(ab&&ab.nodeName.toUpperCase()==="OBJECT"){if(typeof ab.SetVariable!==D){aa=ab}else{aa=ab.getElementsByTagName(r)[0]||ab}}return aa}function A(){return !a&&F("6.0.65")&&(O.win||O.mac)&&!(O.wk&&O.wk<312)}function R(ad,ae,aa,ac){var ah=c(aa);aa=W(aa);a=true;E=ac||null;B={success:false,id:aa};if(ah){if(ah.nodeName.toUpperCase()=="OBJECT"){I=J(ah);p=null}else{I=ah;p=aa}ad.id=S;if(typeof ad.width==D||(!/%$/.test(ad.width)&&n(ad.width)<310)){ad.width="310"}if(typeof ad.height==D||(!/%$/.test(ad.height)&&n(ad.height)<137)){ad.height="137"}var ag=O.ie?"ActiveX":"PlugIn",af="MMredirectURL="+encodeURIComponent(Q.location.toString().replace(/&/g,"%26"))+"&MMplayerType="+ag+"&MMdoctitle="+encodeURIComponent(h.title.slice(0,47)+" - Flash Player Installation");if(typeof ae.flashvars!=D){ae.flashvars+="&"+af}else{ae.flashvars=af}if(O.ie&&ah.readyState!=4){var ab=C("div");
  aa+="SWFObjectNew";ab.setAttribute("id",aa);ah.parentNode.insertBefore(ab,ah);ah.style.display="none";y(ah)}u(ad,ae,aa)}}function b(ab){if(O.ie&&ab.readyState!=4){ab.style.display="none";var aa=C("div");ab.parentNode.insertBefore(aa,ab);aa.parentNode.replaceChild(J(ab),aa);y(ab)}else{ab.parentNode.replaceChild(J(ab),ab)}}function J(af){var ae=C("div");if(O.win&&O.ie){ae.innerHTML=af.innerHTML}else{var ab=af.getElementsByTagName(r)[0];if(ab){var ag=ab.childNodes;if(ag){var aa=ag.length;for(var ad=0;ad<aa;ad++){if(!(ag[ad].nodeType==1&&ag[ad].nodeName=="PARAM")&&!(ag[ad].nodeType==8)){ae.appendChild(ag[ad].cloneNode(true))}}}}}return ae}function k(aa,ab){var ac=C("div");ac.innerHTML="<object classid='clsid:D27CDB6E-AE6D-11cf-96B8-444553540000'><param name='movie' value='"+aa+"'>"+ab+"</object>";return ac.firstChild}function u(ai,ag,ab){var aa,ad=c(ab);ab=W(ab);if(O.wk&&O.wk<312){return aa}if(ad){var ac=(O.ie)?C("div"):C(r),af,ah,ae;if(typeof ai.id==D){ai.id=ab}for(ae in ag){if(ag.hasOwnProperty(ae)&&ae.toLowerCase()!=="movie"){e(ac,ae,ag[ae])}}if(O.ie){ac=k(ai.data,ac.innerHTML)}for(af in ai){if(ai.hasOwnProperty(af)){ah=af.toLowerCase();if(ah==="styleclass"){ac.setAttribute("class",ai[af])}else{if(ah!=="classid"&&ah!=="data"){ac.setAttribute(af,ai[af])}}}}if(O.ie){P[P.length]=ai.id}else{ac.setAttribute("type",q);ac.setAttribute("data",ai.data)}ad.parentNode.replaceChild(ac,ad);aa=ac}return aa}function e(ac,aa,ab){var ad=C("param");ad.setAttribute("name",aa);ad.setAttribute("value",ab);ac.appendChild(ad)}function y(ac){var ab=c(ac);if(ab&&ab.nodeName.toUpperCase()=="OBJECT"){if(O.ie){ab.style.display="none";(function aa(){if(ab.readyState==4){for(var ad in ab){if(typeof ab[ad]=="function"){ab[ad]=null}}ab.parentNode.removeChild(ab)}else{setTimeout(aa,10)}}())}else{ab.parentNode.removeChild(ab)}}}function U(aa){return(aa&&aa.nodeType&&aa.nodeType===1)}function W(aa){return(U(aa))?aa.id:aa}function c(ac){if(U(ac)){return ac}var aa=null;try{aa=h.getElementById(ac)}catch(ab){}return aa}function C(aa){return h.createElement(aa)}function n(aa){return parseInt(aa,10)}function g(ac,aa,ab){ac.attachEvent(aa,ab);K[K.length]=[ac,aa,ab]}function F(ac){ac+="";var ab=O.pv,aa=ac.split(".");aa[0]=n(aa[0]);aa[1]=n(aa[1])||0;aa[2]=n(aa[2])||0;return(ab[0]>aa[0]||(ab[0]==aa[0]&&ab[1]>aa[1])||(ab[0]==aa[0]&&ab[1]==aa[1]&&ab[2]>=aa[2]))?true:false}function v(af,ab,ag,ae){var ad=h.getElementsByTagName("head")[0];if(!ad){return}var aa=(typeof ag=="string")?ag:"screen";if(ae){m=null;G=null}if(!m||G!=aa){var ac=C("style");ac.setAttribute("type","text/css");ac.setAttribute("media",aa);m=ad.appendChild(ac);if(O.ie&&typeof h.styleSheets!=D&&h.styleSheets.length>0){m=h.styleSheets[h.styleSheets.length-1]}G=aa}if(m){if(typeof m.addRule!=D){m.addRule(af,ab)}else{if(typeof h.createTextNode!=D){m.appendChild(h.createTextNode(af+" {"+ab+"}"))}}}}function w(ad,aa){if(!j){return}var ab=aa?"visible":"hidden",ac=c(ad);if(L&&ac){ac.style.visibility=ab}else{if(typeof ad==="string"){v("#"+ad,"visibility:"+ab)}}}function N(ab){var ac=/[\\\"<>\.;]/;var aa=ac.exec(ab)!=null;return aa&&typeof encodeURIComponent!=D?encodeURIComponent(ab):ab}var d=function(){if(O.ie){window.attachEvent("onunload",function(){var af=K.length;for(var ae=0;ae<af;ae++){K[ae][0].detachEvent(K[ae][1],K[ae][2])}var ac=P.length;for(var ad=0;ad<ac;ad++){y(P[ad])}for(var ab in O){O[ab]=null}O=null;for(var aa in swfobject){swfobject[aa]=null}swfobject=null})}}();return{registerObject:function(ae,aa,ad,ac){if(O.w3&&ae&&aa){var ab={};ab.id=ae;ab.swfVersion=aa;ab.expressInstall=ad;ab.callbackFn=ac;o[o.length]=ab;w(ae,false)}else{if(ac){ac({success:false,id:ae})}}},getObjectById:function(aa){if(O.w3){return z(aa)}},embedSWF:function(af,al,ai,ak,ab,ae,ad,ah,aj,ag){var ac=W(al),aa={success:false,id:ac};if(O.w3&&!(O.wk&&O.wk<312)&&af&&al&&ai&&ak&&ab){w(ac,false);M(function(){ai+="";ak+="";var an={};if(aj&&typeof aj===r){for(var aq in aj){an[aq]=aj[aq]}}an.data=af;an.width=ai;an.height=ak;var ar={};if(ah&&typeof ah===r){for(var ao in ah){ar[ao]=ah[ao]}}if(ad&&typeof ad===r){for(var am in ad){if(ad.hasOwnProperty(am)){var ap=(l)?encodeURIComponent(am):am,at=(l)?encodeURIComponent(ad[am]):ad[am];if(typeof ar.flashvars!=D){ar.flashvars+="&"+ap+"="+at}else{ar.flashvars=ap+"="+at}}}}if(F(ab)){var au=u(an,ar,al);if(an.id==ac){w(ac,true)}aa.success=true;aa.ref=au;aa.id=au.id}else{if(ae&&A()){an.data=ae;R(an,ar,al,ag);return}else{w(ac,true)}}if(ag){ag(aa)}})}else{if(ag){ag(aa)}}},switchOffAutoHideShow:function(){j=false},enableUriEncoding:function(aa){l=(typeof aa===D)?true:aa},ua:O,getFlashPlayerVersion:function(){return{major:O.pv[0],minor:O.pv[1],release:O.pv[2]}},hasFlashPlayerVersion:F,createSWF:function(ac,ab,aa){if(O.w3){return u(ac,ab,aa)}else{return undefined}},showExpressInstall:function(ac,ad,aa,ab){if(O.w3&&A()){R(ac,ad,aa,ab)}},removeSWF:function(aa){if(O.w3){y(aa)}},createCSS:function(ad,ac,ab,aa){if(O.w3){v(ad,ac,ab,aa)}},addDomLoadEvent:M,addLoadEvent:s,getQueryParamValue:function(ad){var ac=h.location.search||h.location.hash;
  if(ac){if(/\?/.test(ac)){ac=ac.split("?")[1]}if(ad==null){return N(ac)}var ab=ac.split("&");for(var aa=0;aa<ab.length;aa++){if(ab[aa].substring(0,ab[aa].indexOf("="))==ad){return N(ab[aa].substring((ab[aa].indexOf("=")+1)))}}}return""},expressInstallCallback:function(){if(a){var aa=c(S);if(aa&&I){aa.parentNode.replaceChild(I,aa);if(p){w(p,true);if(O.ie){I.style.display="block"}}if(E){E(B)}}a=false}},version:"2.3"}}();

// play Event
var PLAY_ERROR = "RTMPMEDIA.PLAY.ERROR";
var PLAY_INFO = "RTMPMEDIA.PLAY.INFO";
var PLAY_NETSTREAM_INFO = "RTMPMEDIA.PLAY.NETSTREAM.INFO";
// publish Event
var PUBLISH_ERROR = "RTMPMEDIA.PUBLISH.ERROR";
var PUBLISH_INFO = "RTMPMEDIA.PUBLISH.INFO";
var PUBLISH_NETSTREAM_INFO = "RTMPMEDIA.PUBLISH.NETSTREAM.INFO";
// schedul Event
var SCHEDULE_RESULT = "SchedulRequest.Result";
var SCHEDULE_ERROR = "SchedulRequest.Error";
var SCHEDULE_INFO = "SchedulRequest.Info";
var SCHEDULE_FINISH = "RtmpMedia.Initialize.Success";
// server version Event
var GET_SVR_VERSION_ERR = "GetSvrVersion.Error";
var GET_SVR_VERSION_INFO = "GetSvrVersion.Info";
// client version Event
var CHECK_VERSION_INFO = "Check.Version.Info";
var CHECK_VERSION_ERROR = "Check.Version.Error";
// media Event
var RTMP_MEDIA_ERROR = "RtmpMedia.Error";
var RTMP_MEDIA_INFO = "RtmpMedia.Info";
var RTMP_MEDIA_NETSTREAM_INFO = "RtmpMedia.NetStreamInfo";
var RTMP_MEDIA_DEBUG = "RtmpMedia.Debug";
var RTMP_MEDIA_READY = "RtmpMedia.Ready";
var RTMP_MEDIA_STATISTICS = "RtmpMedia.Statistics";
// media control Event
var RTMP_MEIDA_CONTROL_INFO = "RtmpMedia.Control.Info";
var RTMP_MEIDA_CONTROL_ERROR = "RtmpMedia.Control.Error";
// socket Event
var SOCKET_PING_CONNECT = "SocketPing.Connected";
var SOCKET_PING_ERROR = "SocketPing.Error";
var SOCKET_PING_PING_DONE = "SocketPing.Ping.Done";
// media device Event
var MEDIA_DEVICE_INFO = "Media.Device.Info";
var RTMP_PEPFLASH = "Rtmp.PepFlash";

var UUID_BASE = 0;
var THIS_SWF_NAME = "http://cdn.aodianyun.com/lss/lssplayer/vvMedia.swf";
var globalUUID_CallbackFuncMap = {};
var globalUUID_OnSwfReadyFuncMap = {};
// 视频显示对象
function Video(id, width, height, callbackFunc, params) {
  if (typeof id == "number") {
    id = parseInt(id).toString();
  } else if (typeof id == "string"){
  }else{
    return;
  }
  if (typeof params == "object") {
    var len = 0;
    for (var i in params) {
      len++;
    }
    if (len) {
      this.params /*object*/ = params;
    }
  }
  this.id /*string*/ = id;
  this.uuid /*string*/ = generateUUID();
  this.width /*string*/ = width;
  this.height /*string*/ = height;
  this.params /*object*/ = null;
  this.handle = null;
  createVideo(this.id, this.uuid, this.width, this.height, this.params);
  if (typeof callbackFunc == "function") {
    globalUUID_CallbackFuncMap[this.uuid] = callbackFunc;
  }
  globalUUID_OnSwfReadyFuncMap[this.uuid] = this.onSwfReady;
}
// SWF加载完成消息
Video.prototype.onSwfReady = function () {
  this.handle = document.getElementById(this.uuid);
  if (this.handle) {
  }else {
    alert("can't find swf");
  }
}
// 初始化连接
// 注：如果rtmpAddr有多个，使用英文逗号分割

Video.prototype.initConnect = function (rtmpAddr,/*string*/
                                        rtmpLive,/*string*/
                                        rtmpStream,/*string*/
                                        rtmpArea,/*string*/
                                        schedulingPing,/*uint*/
                                        limitCheckPing,/*uint*/
                                        checkPingTimer,/*uint*/
                                        userID,/*string*/
                                        isHD,/*boolean*/
                                        session,/*string*/
                                        isUDP,/*boolean*/
                                        key/*string*/) {
  if (this.handle) {
    if (typeof rtmpAddr != "string"
      || typeof rtmpLive != "string"
      || typeof rtmpStream != "string"
      || typeof rtmpArea != "string"
      || typeof userID != "string"
      || typeof session != "string"
      || typeof isHD != "boolean"
      || typeof isUDP != "boolean"
      || typeof key != "string"){
      return;
    }
    if (typeof schedulingPing == "number" || typeof schedulingPing == "string") {
      schedulingPing = parseInt(schedulingPing);
    }else{
      return;
    }
    if (typeof limitCheckPing == "number" || typeof limitCheckPing == "string") {
      limitCheckPing = parseInt(limitCheckPing);
    }else{
      return;
    }
    if (typeof checkPingTimer == "number" || typeof checkPingTimer == "string") {
      checkPingTimer = parseInt(checkPingTimer);
    }else{
      return;
    }
    this.handle.initConnect(encodeFlashData(rtmpAddr),
      encodeFlashData(rtmpLive),
      encodeFlashData(rtmpStream),
      encodeFlashData(rtmpArea),
      1500,
      300,
      1000,
      encodeFlashData(userID),
      isHD,
      encodeFlashData(session),
      isUDP,
      encodeFlashData(key));
  }
}


Video.prototype.initConnectad = function () {
  if (this.handle) {
    this.handle.initConnectad();
  }
}

// 关闭连接
Video.prototype.closeConnect = function () {
  if (this.handle) {
    this.handle.closeConnect();
  }
}
// 上麦
Video.prototype.startPublish = function (width,/*uint*/
                                         height,/*uint*/
                                         micID,/*uint*/
                                         camID,/*uint*/
                                         audioCodec,/*string*/
                                         videoCodec,/*string*/
                                         audioKBitrate,/*uint*/
                                         audioSamplerate,/*uint*/
                                         fps,/*uint*/
                                         keyFrameInterval,/*uint*/
                                         videoKBitrate,/*uint*/
                                         videoQuality,/*uint*/
                                         volume,/*uint*/
                                         isUseCam,/*boolean*/
                                         isUseMic,/*boolean*/
                                         isHD,/*boolean*/
                                         isUDP,/*boolean*/
                                         isMute/*boolean*/) {
  if (this.handle) {
    if (typeof audioCodec != "string"
      || typeof videoCodec != "string"
      || typeof isUseCam != "boolean"
      || typeof isUseMic != "boolean"
      || typeof isHD != "boolean"
      || typeof isUDP != "boolean"
      || typeof isMute != "boolean"){
      return;
    }
    if (typeof width == "number" || typeof width == "string") {
      width = parseInt(width);
    }else{
      return;
    }
    if (typeof height == "number" || typeof height == "string") {
      height = parseInt(height);
    }else{
      return;
    }
    if (typeof micID == "number" || typeof micID == "string") {
      micID = parseInt(micID);
    }else{
      return;
    }
    if (typeof camID == "number" || typeof camID == "string") {
      camID = parseInt(camID);
    }else{
      return;
    }
    if (typeof audioKBitrate == "number" || typeof audioKBitrate == "string") {
      audioKBitrate = parseInt(audioKBitrate);
    }else{
      return;
    }
    if (typeof audioSamplerate == "number" || typeof audioSamplerate == "string") {
      audioSamplerate = parseInt(audioSamplerate);
    }else{
      return;
    }
    if (typeof fps == "number" || typeof fps == "string") {
      fps = parseInt(fps);
    }else{
      return;
    }
    if (typeof keyFrameInterval == "number" || typeof keyFrameInterval == "string") {
      keyFrameInterval = parseInt(keyFrameInterval);
    }else{
      return;
    }
    if (typeof videoKBitrate == "number" || typeof videoKBitrate == "string") {
      videoKBitrate = parseInt(videoKBitrate);
    }else{
      return;
    }
    if (typeof videoQuality == "number" || typeof videoQuality == "string") {
      videoQuality = parseInt(videoQuality);
    }else{
      return;
    }
    if (typeof volume == "number" || typeof volume == "string") {
      volume = parseInt(volume);
    }else{
      return;
    }
    this.handle.startPublish(width,
      height,
      micID,
      camID,
      encodeFlashData(audioCodec),
      encodeFlashData(videoCodec),
      audioKBitrate,
      audioSamplerate,
      fps,
      keyFrameInterval,
      videoKBitrate,
      videoQuality,
      volume,
      isUseCam,
      isUseMic,
      isHD,
      isUDP,
      isMute);
  }
}
// 暂停上麦
Video.prototype.pausePublish = function () {
  if (this.handle) {
    this.handle.pausePublish();
  }
}
// 停止上麦
Video.prototype.stopPublish = function () {
  if (this.handle) {
    this.handle.stopPublish();
  }
}
// 播放
Video.prototype.startPlay = function ( rtmpStream, /*string*/
                                       bufferTime,/*uint*/
                                       speedupRange,/*uint reserved,set 0*/
                                       speedupTime,/*uint reserved,set 0*/
                                       speedupSpeed,/*uint reserved,set 0*/
                                       volume,/*uint*/
                                       isMute/*Boolean*/) {

  if (this.handle) {
    if (typeof isMute != "boolean"){
      return;
    }
    if (typeof bufferTime == "number" || typeof bufferTime == "string") {
      bufferTime = parseInt(bufferTime);
    }else{
      return;
    }
    if (typeof speedupRange == "number" || typeof speedupRange == "string") {
      speedupRange = parseInt(speedupRange);
    }else{
      return;
    }
    if (typeof speedupTime == "number" || typeof speedupTime == "string") {
      speedupTime = parseInt(speedupTime);
    }else{
      return;
    }
    if (typeof speedupSpeed == "number" || typeof speedupSpeed == "string") {
      speedupSpeed = parseInt(speedupSpeed);
    }else{
      return;
    }
    if (typeof volume == "number" || typeof volume == "string") {
      volume = parseInt(volume);
    }else{
      return;
    }
    //alert("String:"+String(rtmpStream));
    this.handle.startPlay_(rtmpStream, bufferTime, speedupRange, speedupTime, speedupSpeed, volume, isMute);
  }
}

Video.prototype.testDisplay = function () {
  if (this.handle) {
    this.handle.testDisplay();
  }
}

// 暂停播放
Video.prototype.pausePlay = function () {
  if (this.handle) {
    this.handle.pausePlay();
  }
}
// 停止播放
Video.prototype.stopPlay = function () {
  if (this.handle) {
    this.handle.stopPlay_();
  }
}
// 暂停上麦/播放
Video.prototype.pause = function () {
  this.pausePublish();
  this.pausePlay();
}
// 停止上麦/播放
Video.prototype.stop = function () {
  this.stopPublish();
  this.stopPlay();
}
// 切换务器，initConnect()之后调用有效
Video.prototype.changeServer = function (addr/*string*/, lineType/*string*/){
  if (this.handle) {
    if (typeof addr != "string"
      || typeof lineType != "string"){
      return;
    }
    return this.handle.changeServer(encodeFlashData(addr), encodeFlashData(lineType));
  }
}
//获取play流信息
Video.prototype.getPlayStreamInfo = function () /*Number*/{
  if (this.handle) {
    return this.handle.getPlayStreamInfo();
  }
}
//获取publish流信息
Video.prototype.getPublishStreamInfo = function () /*Number*/{
  if (this.handle) {
    return this.handle.getPublishStreamInfo();
  }
}
// 获取play累计流量
Video.prototype.getByteCount = function () /*Number*/{
  if (this.handle) {
    return this.handle.getByteCount();
  }
}
//获取play平均码率
Video.prototype.getAvgBitrate = function () /*Number*/{
  if (this.handle) {
    return this.handle.getAvgBitrate();
  }
}
//获取play最大码率
Video.prototype.getMaxBitrate = function () /*Number*/{
  if (this.handle) {
    return this.handle.getMaxBitrate();
  }
}

// 获取publish累计流量
Video.prototype.getPublishByteCount = function () /*Number*/{
  if (this.handle) {
    return this.handle.getPublishByteCount();
  }
}
//获取publish平均码率
Video.prototype.getPublishAvgBitrate = function () /*Number*/{
  if (this.handle) {
    return this.handle.getPublishAvgBitrate();
  }
}
//获取publish最大码率
Video.prototype.getPublishMaxBitrate = function () /*Number*/{
  if (this.handle) {
    return this.handle.getPublishMaxBitrate();
  }
}

//  当前帧率
Video.prototype.getCurrentFPS= function () /*Number*/{
  if (this.handle) {
    return this.handle.getCurrentFPS();
  }
}
//音频码率
Video.prototype.getAudioBytesPerSecond= function () /*Number*/{
  if (this.handle) {
    return this.handle.getAudioBytesPerSecond();
  }
}
//视频码率
Video.prototype.getVideoBytesPerSecond= function () /*Number*/{
  if (this.handle) {
    return this.handle.getVideoBytesPerSecond();
  }
}
//当前码率
Video.prototype.getCurrentBytesPerSecond= function () /*Number*/{
  if (this.handle) {
    return this.handle.getCurrentBytesPerSecond();
  }
}
//获取关键帧间隔
Video.prototype.getKeyFrameInterval= function () /*Number*/{
  if (this.handle) {
    return this.handle.getKeyFrameInterval();
  }
}
//获取字节数
Video.prototype.getCurrentByteCount= function () /*Number*/{
  if (this.handle) {
    return this.handle.getCurrentByteCount();
  }
}
//缓冲区时间
Video.prototype.getBufferLength= function () /*Number*/{
  if (this.handle) {
    return this.handle.getBufferLength();
  }
}
//音频缓冲区时间
Video.prototype.getAudioBufferLength= function () /*Number*/{
  if (this.handle) {
    return this.handle.getAudioBufferLength();
  }
}
//视频缓冲区时间
Video.prototype.getVideoBufferLength= function () /*Number*/{
  if (this.handle) {
    return this.handle.getVideoBufferLength();
  }
}
//音频编码
Video.prototype.getAudioCodec= function () /*String*/{
  if (this.handle) {
    return this.handle.getAudioCodec();
  }
}
//视频编码
Video.prototype.getVideoCodec= function () /*String*/{
  if (this.handle) {
    return this.handle.getVideoCodec();
  }
}
//原始视频宽
Video.prototype.getVideoWidth= function () /*Number*/{
  if (this.handle) {
    return this.handle.getVideoWidth();
  }
}
//原始视频高
Video.prototype.getVideoHeight= function () /*Number*/{
  if (this.handle) {
    return this.handle.getVideoHeight();
  }
}
//上麦视频宽
Video.prototype.getPublishVideoWidth= function () /*Number*/{
  if (this.handle) {
    return this.handle.getPublishVideoWidth();
  }
}
//上麦视频高
Video.prototype.getPublishVideoHeight= function () /*Number*/{
  if (this.handle) {
    return this.handle.getPublishVideoHeight();
  }
}

//音频设备
Video.prototype.getMicName= function () /*String*/{
  if (this.handle) {
    return this.handle.getMicName();
  }
}
//视频设备
Video.prototype.getCameraName= function () /*String*/{
  if (this.handle) {
    return this.handle.getCameraName();
  }
}

// 获取vvMedia版本
Video.prototype.getClientVersion = function ()/*string*/{
  if (this.handle) {
    return this.handle.getClientVersion();
  }
}
// 获取高清插件版本
Video.prototype.getHQVersion = function ()/*string*/{
  if (this.handle) {
    return this.handle.getHQVersion();
  }
}
// 获取受支持的高清插件的最低版本
Video.prototype.getLowestSupportHQVersion = function ()/*string*/{
  if (this.handle) {
    return this.handle.getLowestSupportHQVersion();
  }
}
// 获取flash版本，initConnect()之后调用有效
Video.prototype.getFlashVersion = function ()/*string*/{
  if (this.handle) {
    return this.handle.getFlashVersion();
  }
}
// 获取服务器版本，initConnect()之后调用有效
Video.prototype.getServerVersion = function ()/*string*/{
  if (this.handle) {
    return this.handle.getServerVersion();
  }
}
// 获取当前正在使用的服务器，initConnect()之后调用有效
Video.prototype.getCurrentServer = function ()/*string*/
{
  if (this.handle) {
    return this.handle.getCurrentServer();
  }
}
// 获取当前保存的服务器列表，以逗号分隔
Video.prototype.getChangeSvrList = function()/*string*/
{
  if (this.handle) {
    return this.handle.getChangeSvrList();
  }
}
// 获取音频编码列表，以逗号分隔
Video.prototype.getAudioCodecSet = function ()/*string*/
{
  if (this.handle) {
    return this.handle.getAudioCodecSet();
  }
}
// 获取视频编码列表，以逗号分隔
Video.prototype.getVideoCodecSet = function ()/*string*/
{
  if (this.handle) {
    return this.handle.getVideoCodecSet();
  }
}
// 获取麦克风列表
Video.prototype.getMicList = function ()/*array*/
{
  if (this.handle) {
    return this.handle.getMicList();
  }
}
// 获取摄像头列表
Video.prototype.getCamList = function ()/*array*/
{
  if (this.handle) {
    return this.handle.getCamList();
  }
}
//设置全屏模式,initConnect()之后调用有效
Video.prototype.setFullScreenMode = function (fullScreenMode /*uint*/) {
  if (this.handle)
    if (typeof fullScreenMode == "number" || typeof fullScreenMode == "string") {
      fullScreenMode = parseInt(fullScreenMode);
    }else{
      return;
    }
  return this.handle.setFullScreenMode(fullScreenMode);
}
// 设置高清模式，initConnect()之后调用有效
Video.prototype.setHD = function (isHD /*boolean*/) {
  if (this.handle) {
    if (typeof isHD != "boolean"){
      return;
    }
    return this.handle.setHD(isHD);
  }
}
// 设置UDP模式，initConnect()之后调用有效
Video.prototype.setUDP = function (isUDP /*boolean*/) {
  if (this.handle) {
    if (typeof isUDP != "boolean"){
      return;
    }
    return this.handle.setUDP(isUDP);
  }
}
// 设置音频编码，initConnect()之后调用有效
Video.prototype.setAudioCodec = function (audioCodec /*string*/) {
  if (this.handle) {
    if (typeof audioCodec != "string"){
      return;
    }
    return this.handle.setAudioCodec(encodeFlashData(audioCodec));
  }
}
// 设置视频编码，initConnect()之后调用有效
Video.prototype.setVideoCodec = function (videoCodec /*string*/) {
  if (this.handle) {
    if (typeof videoCodec != "string"){
      return;
    }
    return this.handle.setVideoCodec(encodeFlashData(videoCodec));
  }
}
// 设置音频码率 仅speex编码，initConnect()之后调用有效
Video.prototype.setAudioBitrate = function (audioKBitrate /*uint*/) {
  if (this.handle) {
    if (typeof audioKBitrate == "number" || typeof audioKBitrate == "string") {
      audioKBitrate = parseInt(audioKBitrate);
    }else{
      return;
    }
    return this.handle.setAudioBitrate(audioKBitrate);
  }
}
// 设置音频采样率，initConnect()之后调用有效
Video.prototype.setAudioSamplerate = function (audioSamplerate /*uint*/) {
  if (this.handle) {
    if (typeof audioSamplerate == "number" || typeof audioSamplerate == "string") {
      audioSamplerate = parseInt(audioSamplerate);
    }else{
      return;
    }
    return this.handle.setAudioSamplerate(audioSamplerate);
  }
}
// 设置音频通道，initConnect()之后调用有效
Video.prototype.setAudioChannelCount = function (channelCount /*uint*/) {
  if (this.handle) {
    if (typeof channelCount == "number" || typeof channelCount == "string") {
      channelCount = parseInt(channelCount);
    }else{
      return;
    }
    return this.handle.setAudioChannelCount(channelCount);
  }
}
// 设置音频采样精度，initConnect()之后调用有效
Video.prototype.setAudioBitPerSample = function (audioBitPerSample /*uint*/) {
  if (this.handle) {
    if (typeof audioBitPerSample == "number" || typeof audioBitPerSample == "string") {
      audioBitPerSample = parseInt(audioBitPerSample);
    }else{
      return;
    }
    return this.handle.setAudioBitPerSample(audioBitPerSample);
  }
}
// 设置音频采样精度，initConnect()之后调用有效，参数keyFrameInterval 默认值为90 ，范围为0~180
Video.prototype.setAudioBitPerSample = function (audioBitPerSample /*uint*/) {
  if (this.handle) {
    if (typeof audioBitPerSample == "number" || typeof audioBitPerSample == "string") {
      audioBitPerSample = parseInt(audioBitPerSample);
    }else{
      return;
    }
    return this.handle.setAudioBitPerSample(audioBitPerSample);
  }
}
// 设置关键帧间隔，initConnect()之后调用有效
Video.prototype.setKeyFrameInterval = function (keyFrameInterval /*uint*/) {
  if (this.handle) {
    if (typeof keyFrameInterval == "number" || typeof keyFrameInterval == "string") {
      keyFrameInterval = parseInt(keyFrameInterval);
    }else{
      return;
    }
    return this.handle.setKeyFrameInterval(keyFrameInterval);
  }
}
// 设置视频宽高，帧率，initConnect()之后调用有效
Video.prototype.setCameraMode = function (width /*uint*/, height /*uint*/, fps /*uint*/) {
  if (this.handle) {
    if (typeof width == "number" || typeof width == "string") {
      width = parseInt(width);
    }else{
      return;
    }
    if (typeof height == "number" || typeof height == "string") {
      height = parseInt(height);
    }else{
      return;
    }
    if (typeof fps == "number" || typeof fps == "string") {
      fps = parseInt(fps);
    }else{
      return;
    }
    return this.handle.setCameraMode(width, height, fps);
  }
}
// 设置视频码率，质量，initConnect()之后调用有效
Video.prototype.setCameraQuality = function (videoKBitrate /*uint*/, videoQuality /*uint*/) {
  if (this.handle) {
    if (typeof videoKBitrate == "number" || typeof videoKBitrate == "string") {
      videoKBitrate = parseInt(videoKBitrate);
    }else{
      return;
    }
    if (typeof videoQuality == "number" || typeof videoQuality == "string") {
      videoQuality = parseInt(videoQuality);
    }else{
      return;
    }
    return this.handle.setCameraQuality(videoKBitrate, videoQuality);
  }
}
// 设置是否使用摄像头，initConnect()之后调用有效
Video.prototype.setIsUseCam = function (isUseCam /*Boolean*/) {
  if (this.handle) {
    if (typeof isUseCam != "boolean"){
      return;
    }
    return this.handle.setIsUseCam(isUseCam);
  }
}
// 设置是否使用麦克风，initConnect()之后调用有效
Video.prototype.setIsUseMic = function (isUseMic /*Boolean*/) {
  if (this.handle) {
    if (typeof isUseMic != "boolean"){
      return;
    }
    return this.handle.setIsUseMic(isUseMic);
  }
}
// 设置音量，initConnect()之后调用有效
Video.prototype.setVolume = function (volume /*uint*/) {
  if (this.handle) {
    if (typeof volume == "number" || typeof volume == "string") {
      volume = parseInt(volume);
    }else{
      return;
    }
    return this.handle.setVolume(volume);
  }
}
// 设置是否静音，initConnect()之后调用有效
Video.prototype.setMute = function (isMute /*Boolean*/) {
  if (this.handle) {
    if (typeof isMute != "boolean"){
      return;
    }
    return this.handle.setMute(isMute);
  }
}
// 播放模式 实时、质量、自定义，initConnect()之后调用有效
Video.prototype.setPlayMode = function (bufferTime /*uint*/,
                                        speedupRange /*uint*/,
                                        speedupTime /*uint*/,
                                        speedupSpeed /*uint*/) {
  if (this.handle) {
    if (typeof bufferTime == "number" || typeof bufferTime == "string") {
      bufferTime = parseInt(bufferTime);
    }else{
      return;
    }
    if (typeof speedupRange == "number" || typeof speedupRange == "string") {
      speedupRange = parseInt(speedupRange);
    }else{
      return;
    }
    if (typeof speedupTime == "number" || typeof speedupTime == "string") {
      speedupTime = parseInt(speedupTime);
    }else{
      return;
    }
    if (typeof speedupSpeed == "number" || typeof speedupSpeed == "string") {
      speedupSpeed = parseInt(speedupSpeed);
    }else{
      return;
    }
    return this.handle.setPlayMode(bufferTime, speedupRange, speedupTime, speedupSpeed);
  }
}
// 上麦时，切换摄像头，initConnect()之后调用有效
Video.prototype.setCam = function (camID /*int*/) {
  if (this.handle) {
    if (typeof camID == "number" || typeof camID == "string") {
      camID = parseInt(camID);
    }else{
      return;
    }
    return this.handle.setCam(camID);
  }
}
// 上麦时，切换麦克风，initConnect()之后调用有效
Video.prototype.setMic = function (micID /*int*/) {
  if (this.handle) {
    if (typeof micID == "number" || typeof micID == "string") {
      micID = parseInt(micID);
    }else{
      return;
    }
    return this.handle.setMic(micID);
  }
}
// 设置播放窗口大小，initConnect()之后调用有效
Video.prototype.setVideoDisplaySize = function (width/*uint*/, height/*uint*/) {
  if (this.handle) {
    if (typeof width == "number" || typeof width == "string") {
      width = parseInt(width);
    }else{
      return;
    }
    if (typeof height == "number" || typeof height == "string") {
      height = parseInt(height);
    }else{
      return;
    }
    return this.handle.setVideoDisplaySize(width, height);
  }
}
// 设置是否接收音频，initConnect()之后调用有效
Video.prototype.setReceiveAudio = function (isReceive/*Boolean*/) {
  if (this.handle) {
    return this.handle.setReceiveAudio(isReceive);
  }
}
// 设置是否接收视频，initConnect()之后调用有效
Video.prototype.setReceiveVideo = function (isReceive/*Boolean*/) {
  if (this.handle) {
    if (typeof isReceive != "boolean"){
      return;
    }
    return this.handle.setReceiveVideo(isReceive);
  }
}
// 获取flash版本，initConnect()之后调用有效
Video.prototype.getFlashVersion = function ()/*string*/{
  if (this.handle) {
    return this.handle.getFlashVersion();
  }
}
// 设置使用麦克风，initConnect()之后调用有效
/*bool*/ Video.prototype.setCapAudioFromMic = function (){
  if (this.handle) {
    return this.handle.setCapAudioFromMic();
  }
}
// 设置使用混音，initConnect()之后调用有效
/*bool*/ Video.prototype.setCapAudioFromStereo = function (){
  if (this.handle) {
    return this.handle.setCapAudioFromStereo();
  }
}
// 下载高清插件
Video.prototype.downloadHD = function () {
  if (this.handle) {
    return this.handle.downloadHD();
  }
}
// 浏览器是否支持使用高清 return {type:2, describe:"HQPlugin Need Update"}
/**
 * type
 * 1. 插件可以使用
 * 2. 插件未安装
 * 3. 插件需要更新
 * 4. 浏览器不支持插件
 **/
Video.prototype.checkPlugin = function () {
  if (this.handle) {
    return this.handle.checkPlugin();
  }
}
// 设置带宽不足提示条件 ping
Video.prototype.setAvgPing = function (ping/*uint*/) {
  if (this.handle) {
    if (typeof ping == "number" || typeof ping == "string") {
      ping = parseInt(ping);
    }else{
      return;
    }
    return this.handle.setAvgPing(ping);
  }
}
// 添加回调
Video.prototype.addEventListener = function (callbackFunc) {
  if (typeof callbackFunc == "function") {
    globalUUID_CallbackFuncMap[this.uuid] = callbackFunc;
  }
}
// 回调消息
function lssCallBack(uuid, type, info) {
  if (globalUUID_CallbackFuncMap[uuid]){
    globalUUID_CallbackFuncMap[uuid](type, info);
  }
}
// 生成全局UUID
// 注意：不包含以下字符：. - + * \ /
function generateUUID() {
  UUID_BASE++;
  return ('vvMedia' + UUID_BASE);
}
// 所有发送给flash的字符串都必须经过此方法编码
function encodeFlashData(str) {
  str = str.toString().replace(/\\/g, '\\\\');
  str = str.replace(/&/g, '__FLASH__AMPERSAND');
  return str;
}
// 创建SWF对象
function createVideo(id, uuid, width, height, param) {
  param = param || {};
  var displayid = id.toString();
  var swfVersionStr = "11.1.0";
  // To use express install, set to playerProductInstall.swf, otherwise the empty string.
  var xiSwfUrlStr = "http://cdn.aodianyun.com/lss/lssplayer/playerProductInstall.swf";
  var flashvars = {};
  flashvars.uuid = uuid;
  var params = {};
  params.quality = param["quality"] || "high";
  params.bgcolor = param["bgcolor"] || "#ffffff";
  //params.allowscriptaccess = param["allowscriptaccess"] || "sameDomain";
  params.allowfullscreen = param["allowfullscreen"] || "true";
  params.allowScriptAccess = "always";
  var attributes = {};
  attributes.id = uuid;
  attributes.name = uuid;
  attributes.align = param["align"] || "middle";
  swfobject.embedSWF(
    THIS_SWF_NAME, displayid,
    width, height,
    swfVersionStr, xiSwfUrlStr,
    flashvars, params, attributes);
  swfobject.createCSS("#flashContent", "display:block;text-align:left;");
}


function aodianLss(conf){
  if (!conf.container || conf.container == "" || !conf.url || conf.url == "") {
    console.log("缺少必要的参数：container、url");
    return;
  }
  if(!document.getElementById(conf.container)){
    console.log("ID为：" + conf.container + "的容器不存在");
    return;
  }
  //var mode = /^rtmp\:\/\/(\d{1,8})\.lsspublish\.aodianyun\.com\/([a-z\_\-A-Z\-0-9]*)(\?k\=([a-z0-9]*)\&t\=\d{10,11})?\/([a-z\_\-A-Z\-0-9]*)(\?k\=([a-z0-9]*)\&t\=\d{10,11})?$/;
  var mode = /^rtmp\:\/\/(.*)\/([a-z\_\-A-Z\-0-9]*)(\?k\=([a-z0-9]*)\&t\=\d{10,11})?\/([a-z\_\-A-Z\-0-9]*)(\?k\=([a-z0-9]*)\&t\=\d{10,11})?$/;
  if(!mode.test(conf.url)){
    console.log("发布地址格式错误");
    return;
  }
  var arr = conf.url.match(mode);

  conf.uin = 0;
  conf.cname = arr[1];
  conf.app = arr[2];
  conf.key = '';
  conf.ck = arr[3] ? arr[3] : '';
  conf.pk = arr[6] ? arr[6] : '';
  conf.stream = arr[5] + conf.pk;;
  //conf.addr = 'rtmp://'+ conf.uin +'.lsspublish.aodianyun.com/' + conf.app + conf.ck;
  conf.addr = 'rtmp://'+ conf.cname +'/' + conf.app + conf.ck;

  var pageHost = ((document.location.protocol == "https:") ? "https://" : "http://");
  var html = '<p>To view this page ensure that Adobe Flash Player version 11.0.0 or greater is installed.</p><a href="http://www.adobe.com/go/getflashplayer"><img src="' + pageHost + '"www.adobe.com/images/shared/download_buttons/get_flash_player.gif" alt="Get Adobe Flash player" /></a>';
  $('#'+conf.container).html(html);

  var mode = /^\d{0,6}(\%)?$/;
  var width = mode.test(conf.width) ? conf.width : '100%';
  var height = mode.test(conf.height) ? conf.height : '100%';
  var containerWidth = document.getElementById(conf.container).scrollWidth;
  var containerHeight = document.getElementById(conf.container).scrollHeight;
  var mode = /^\d{0,6}$/;
  if(mode.test(width)){
    width = parseInt(width);
  }
  else{
    width = (width.substr(0,width.length-1).toString(0)/100) * containerWidth;
  }
  if(mode.test(height)){
    height = parseInt(height);
  }
  else{
    height = (height.substr(0,height.length-1).toString(0)/100) * containerHeight;
  }
  var autoconnect = typeof(conf.autoconnect)=='boolean'?conf.autoconnect:true;

  var _camIndexArray = [];//摄像头列表
  var _micIndexArray = [];//麦克风列表
  var _rtmpLive = conf.app;//app名
  var _rtmpAddr = conf.addr;//rtmp地址
  var _rtmpStream = conf.stream;//stream
  var _rtmpKey = '';//密码
  var _rtmpArea = 'hangzhou';//低于
  var _schedulingPing = 1500;//调度时Ping超时
  var _limitCheckPing = 1000;//播放时超过Ping就切换服务器
  var _checkPingTimer = 1000;//检测Ping间隔
  var _userID = 'Test';
  var _isHD = false;//是否高清
  var _session = 'TestSession';
  var _isUDP = false;//是否UDP
  var _speedupRange = 0;
  var _speedupTime = 0;
  var _speedupSpeed = 0;
  var _volume = 80;//音量
  var _isMute = false;//是否静音
  var _totalFlow = 0;//总流量
  var _avgBitrate = 0;//平均码率
  var _maxBitrate = 0;//峰值码率
  var _mediaInfo = '';//流媒体传输信息
  var _streamInfo = '';//stream信息
  var _isUseCam = true;//是否启用摄像头
  var _isUseMic = true;//是否启用声音
  var _audioKBitrate = 44;//音频码率(16~48)(kbps)
  var _audioSamplerate = 44100;//音频采样率(16000~48000)(Hz)
  var _videoFPS = 10;//视频帧率(1~25)
  var _videoKBitrate = 256;//视频码率(96~512)(kbps)
  var _videoQuality = 80;
  var _avgPing = 200;
  var _audioChannelCount = 2;
  var _audioBitPerSample = 16;
  var _clientVersion = '';//客户端版本
  var _flashVersion = '';//flash版本
  var _videoCodec = "h264";//视频编码
  var _audioCodec = "Nellymoser";//音频编码
  var thisHandle = this;

  var player1 = new Video(conf.container,width,height,
    function(type, info){
      switch(type)
      {
        case RTMP_MEDIA_INFO:
          switch(info)
          {
            case "Svr.Version.Success":
              break;
            case "NetConnection.Connect.Success":
            case "ChangeInfo.NetConnection.Connect.Success":
            case "new connect":
              break;
            case SCHEDULE_FINISH:
              thisHandle.startPublish();
              break;
            case RTMP_PEPFLASH:
              alert("警告：\n\n系统检测到您正在使用 Pepper Flash Player，\n\n此版本的 Flash 并不完善，请尝试更换IE浏览器，\n\n或百度“如何禁用Pepper Flash”。");
              thisHandle.closeConnect();
              break;
            default:
              break;
          }
          break;
        case RTMP_MEDIA_ERROR:
          break;
        case MEDIA_DEVICE_INFO:
          switch(info)
          {
            case "AVHardwareDisable":
              alert("flash player 全局设置了禁用硬件设置，修改方法：\nC:\WINDOWS\system32\Macromed\Flash\mms.cfg\n文件，修改为 AVHardwareDisable=0");;
              break;
            //需要添加其他摄像头麦克风禁用的消息
            default:
              break;
          }
          break;
        case RTMP_MEDIA_READY:	//swf加载完成消息
          player1.onSwfReady();
          thisHandle.onSwfReady();
          if(autoconnect){
            thisHandle.initConnect();
          }
          break;
        case RTMP_MEDIA_NETSTREAM_INFO:
          _streamInfo = info;
          break;
        case RTMP_MEDIA_STATISTICS:
          var obj = JSON.parse(info);
          if (obj) {
            if (obj.totalFlow >= 1048576) {
              _totalFlow = (obj.totalFlow / 1048576).toFixed(2) + "MB";
            } else {
              _totalFlow = (obj.totalFlow / 1024).toFixed(2) + "KB";
            }
            _avgBitrate = (obj.avgBitrate / 1000).toFixed(2) + "kb";
            _maxBitrate = (obj.maxBitrate / 1000).toFixed(2) + "kb";
          }
          break;
        default:
          break;
      }
      if (type != RTMP_MEDIA_NETSTREAM_INFO && type != RTMP_MEDIA_STATISTICS){
        var date = new Date();
        _mediaInfo = date.getHours()+":"+date.getMinutes()+":"+date.getSeconds()+"."+date.getMilliseconds()+' '+info+'\n'+_mediaInfo;
      }
    },
    null);

  this.test = function(){alert(123);}

  this.checkPlayer = function(){
    if(typeof(player1) != 'object'){
      console.log("播放器加载失败，请重试");
      return false;
    }
    return true;
  }

  //swf准备完毕
  this.onSwfReady = function(){
    if(!this.checkPlayer()){
      return false;
    }
    // micList
    _micIndexArray = player1.getMicList();
    // camList
    _camIndexArray = player1.getCamList();
    //vvMediaVersion | clientVersion
    _clientVersion = player1.getClientVersion();
    var id=window.setInterval(this.getPublishByteCount(),1000);
    var id1=window.setInterval(this.getPublishAvgBitrate(),1000);
    var id2=window.setInterval(this.getPublishMaxBitrate(),1000);
  }
  //总流量数据
  this.getPublishByteCount = function(){
    if(!this.checkPlayer()){
      return;
    }
    var tempTotalFlow = player1.getPublishByteCount();
    if (tempTotalFlow>0)
    {
      if (tempTotalFlow >= 1048576) {
        _totalFlow.value = (tempTotalFlow / 1048576).toFixed(2) + "MB";
      } else {
        _totalFlow.value = (tempTotalFlow / 1024).toFixed(2) + "KB";
      }
    }
  }
  //平均速率数据
  this.getPublishAvgBitrate = function(){
    if(!this.checkPlayer()){
      return;
    }
    var tempAvgBitrate= player1.getPublishAvgBitrate();
    _avgBitrate.value = (tempAvgBitrate / 1000).toFixed(2) + "kb";
  }
  //最大速率数据
  this.getPublishMaxBitrate = function(){
    if(!this.checkPlayer()){
      return;
    }
    var tempMaxBitrate = player1.getPublishMaxBitrate();
    _maxBitrate.value = (tempMaxBitrate / 1000).toFixed(2) + "kb";
  }
  //初始化连接
  this.initConnect = function(){
    if(!this.checkPlayer()){
      return false;
    }
    if(player1.initConnect( _rtmpAddr,
      _rtmpLive,
      _rtmpStream,
      _rtmpArea,
      _schedulingPing,
      _limitCheckPing,
      _checkPingTimer,
      _userID,
      _isHD,
      _session,
      _isUDP,
      _rtmpKey)){
      _flashVersion = player1.getFlashVersion();
      return true;
    }
    else{
      return false;
    }
  }
  //断开连接
  this.closeConnect = function(){
    if(!this.checkPlayer()){
      return;
    }
    return player1.closeConnect();
  }
  //发布、上麦
  this.startPublish = function(conf){
    if(!this.checkPlayer()){
      return;
    }
    var mode = /^\d+$/;
    var micID = mode.test(conf.micID)&&typeof(_micIndexArray[conf.micID])!='undefined'?conf.micID:'';
    var camID = mode.test(conf.camID)&&typeof(_micIndexArray[conf.camID])!='undefined'?conf.camID:'';
    var audioKBitrate = mode.test(conf.audioKBitrate)&&conf.audioKBitrate>=16&&conf.audioKBitrate<=48?conf.audioKBitrate:44;
    var audioSamplerate = mode.test(conf.audioSamplerate)&&conf.audioSamplerate>=16000&&conf.audioSamplerate<=48000?conf.audioSamplerate:44100;
    var videoFPS = mode.test(conf.videoFPS)&&conf.videoFPS>=1&&conf.videoFPS<=25?conf.videoFPS:10;
    var keyFrameInterval = mode.test(conf.keyFrameInterval)?conf.keyFrameInterval:30;
    var videoKBitrate = mode.test(conf.videoKBitrate)&&conf.videoKBitrate>=96&&conf.videoKBitrate<=512?conf.videoKBitrate:256;
    var videoQuality = mode.test(conf.videoQuality)&&conf.videoQuality>=1&&conf.videoQuality<=85?conf.videoQuality:80;
    var volume = mode.test(conf.volume)&&conf.volume>=0&&conf.volume<=100?conf.volume:80;
    var isUseCam = mode.test(conf.isUseCam)?conf.isUseCam:true;
    var isUseMic = mode.test(conf.isUseMic)?conf.isUseMic:true;
    var isMute = mode.test(conf.isMute)?conf.isMute:false;
    player1.startPublish(width,
      height,
      micID,
      camID,
      _audioCodec,
      _videoCodec,
      audioKBitrate,
      audioSamplerate,
      videoFPS,
      keyFrameInterval,
      videoKBitrate,
      videoQuality,
      volume,
      isUseCam,
      isUseMic,
      _isHD,
      _isUDP,
      isMute);
  }
  //播放
  this.startPlay = function(){
    if(!this.checkPlayer()){
      return;
    }
    player1.startPlay(_rtmpStream,_bufferTime,_speedupRange, _speedupTime,_speedupSpeed,_volume,_isMute);
  }
  //暂停
  this.pause = function(){
    if(!this.checkPlayer()){
      return;
    }
    player1.pause();
  }
  //停止
  this.stopPlayer = function(){
    if(!this.checkPlayer()){
      return;
    }
    player1.stop();
  }
  // 设置音频码率 仅speex编码，initConnect()之后调用有效
  this.setAudioCodec = function(_audioCodec){
    if(!this.checkPlayer()){
      return;
    }
    player1.setAudioCodec(_audioCodec);
  }
  //设置视频编码，initConnect()之后调用有效
  this.setVideoCodec = function(_videoCodec){
    if(!this.checkPlayer()){
      return;
    }
    player1.setVideoCodec(_videoCodec);
  }
  //获得麦克风列表
  this.getMic = function(){
    if(!this.checkPlayer()){
      return false;
    }
    return _micIndexArray;
  }
  //使用、切换麦克风
  this.setMic = function(micID){
    if(!this.checkPlayer()){
      return false;
    }
    if(!_micIndexArray[micID]){
      console.log('无效的麦克风');
      return false;
    }
    return player1.setMic(micID);
  }
  //获得摄像头列表
  this.getCam = function(){
    if(!this.checkPlayer()){
      return false;
    }
    return _camIndexArray;
  }
  //使用、切换摄像头
  this.setCam = function(camID){
    if(!this.checkPlayer()){
      return false;
    }
    if(!_camIndexArray[camID]){
      console.log('无效的摄像头');
      return false;
    }
    return player1.setCam(camID);
  }
  //设置是否使用摄像头
  this.setIsUseCam = function(_isUseCam){
    if(!this.checkPlayer()){
      return false;
    }
    if(typeof(_isUseCam)!='boolean'){
      console.log('参数错误');
      return false;
    }
    player1.setIsUseCam(_isUseCam);
  }
  //设置是否使用麦克风
  this.setIsUseMic = function(_isUseMic){
    if(!this.checkPlayer()){
      return false;
    }
    if(typeof(_isUseMic)!='boolean'){
      console.log('参数错误');
      return false;
    }
    player1.setIsUseMic(_isUseMic);
  }
  //设置视频尺寸，initConnect()之后调用有效
  this.setVideoDisplaySize = function(width,height){
    if(!this.checkPlayer()){
      return false;
    }
    var mode = /^\d+$/;
    if(!mode.test(width) || !mode.test(height)){
      console.log('参数错误');
      return false;
    }
    return player1.setVideoDisplaySize(width,height);
  }
  //设置摄像头捕获画面的大小，帧率，initConnect()之后调用有效
  this.setCameraMode = function(width,height,videoFPS){
    if(!this.checkPlayer()){
      return;
    }
    var mode = /^\d+$/;
    if(!mode.test(width) || !mode.test(height)){
      console.log('参数错误');
      return false;
    }
    if(!mode.test(videoFPS) || videoFPS < 1 || videoFPS > 25){
      console.log('参数错误');
      return false;
    }
    player1.setCameraMode(width,height,videoFPS);
  }
  //设置视频码率，质量，initConnect()之后调用有效
  this.setCameraQuality = function(videoKBitrate,videoQuality){
    if(!this.checkPlayer()){
      return;
    }
    var mode = /^\d+$/;
    if(!mode.test(videoKBitrate) || videoKBitrate < 96 || videoKBitrate > 512){
      console.log('参数错误');
      return false;
    }
    if(!mode.test(videoQuality) || videoQuality < 1 || videoQuality > 85){
      console.log('参数错误');
      return false;
    }
    player1.setCameraQuality(videoKBitrate,videoQuality);
  }
  //设置音频码率，initConnect()之后调用有效
  this.setAudioBitrate = function(audioKBitrate){
    if(!this.checkPlayer()){
      return;
    }
    var mode = /^\d+$/;
    if(!mode.test(audioKBitrate) || audioKBitrate < 16 || audioKBitrate > 48){
      console.log('参数错误');
      return false;
    }
    player1.setAudioBitrate(audioKBitrate);
  }
  //设置音频采样率，initConnect()之后调用有效
  this.setAudioSamplerate = function(audioSamplerate){
    if(!this.checkPlayer()){
      return;
    }
    var mode = /^\d+$/;
    if(!mode.test(audioSamplerate) || audioSamplerate < 16000 || audioSamplerate > 48000){
      console.log('参数错误');
      return false;
    }
    player1.setAudioSamplerate(audioSamplerate);
  }
  //静音，initConnect()之后调用有效
  this.setMute = function(isMute){
    if(!this.checkPlayer()){
      return;
    }
    if(typeof(isMute)!='boolean'){
      console.log('参数错误');
      return;
    }
    player1.setMute(isMute);
  }
  // 设置音量，initConnect()之后调用有效
  this.setVolume = function(volume){
    if(!this.checkPlayer()){
      return;
    }
    var mode = /^\d{1,3}$/;
    if(!mode.test(volume)){
      console.log('音量只能为0-100');
      return;
    }
    volume = parseInt(volume);
    if(volume > 100){
      console.log('音量只能为0-100');
      return;
    }
    player1.setVolume(volume);
  }
  //设置使用麦克风，initConnect()之后调用有效
  this.setCapAudioFromMic = function(){
    if(!this.checkPlayer()){
      return;
    }
    player1.setCapAudioFromMic();
  }
  //设置使用混音，initConnect()之后调用有效
  this.setCapAudioFromStereo = function(){
    if(!this.checkPlayer()){
      return;
    }
    player1.setCapAudioFromStereo();
  }
}