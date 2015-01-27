#budweiser

cloud3edu cloud based education system

##Client
###Prerequisites:
+ node  
`brew install node`
+ npm 
+ bower  
`npm install bower grunt grunt-cli -g`
+ redis  
`brew install redis`
+ *Font Custom (if you want to build font)  
`brew install fontforge ttfautohint`
`gem install fontcustom`

sudo apt-get install fontforge ttfautohint
wget http://people.mozilla.com/~jkew/woff/woff-code-latest.zip
unzip woff-code-latest.zip -d sfnt2woff && cd sfnt2woff && make && sudo mv sfnt2woff /usr/local/bin/
gem install fontcustom

###Downloand node&bower packages
```
npm install
bower install
```
###Test and build
####build font (optionals)
```
grunt webfont
```
####build
```
grunt build
grunt test
```
###Run
start redis server at localhost:6379, then

`grunt serve`


###安装beat_me_log的处理环境
需要依赖perl，安装一些模块，日志存放路径/data/log
```
sudo cpan JSON
sudo cpan Date::Calc
```

执行方法：
```
cd PROJ_DIR/scripts
sh process_beat_me_log_to_db.sh 2015-01-23#可以提供需要处理的日期格式，默认处理前一天的
sh process_beat_me_log_to_db.sh
```


###Qiniu CDN
to sync bower files
#### Pre-request: install qiniu-devtool
run `path/to/qrsync qiniu_conf.json`

### 百度统计
trackEvents cate, event, label, value  
```
cate
  event
    label
```
+ views 用来收集页面使用率
  + open 页面打开，对应的label可以记录你的页面名称，value可以用来记录org，url等json数据
+ action 用来检测某些功能使用率
  + uploadFile
  + saveProfile
  + uploadVideo
  + uploadSlide
  + convertSlide
+ error 用来收集production errors
  + onJSError
  + onAngularError
  + onHttpError
  + onVideoError
  + onPayError
  + onFileUploadError
  + onVideoUploadError
  + onConvertError


###Troubleshooting
+ After using `grunt serve` and get [Fatal error: spawn EMFILE](https://github.com/gruntjs/grunt/issues/788)  
Fixed: add `ulimit -S -n 2048` to your `~/.bash_profile`

###Contributing
Sublime is recommended.  
Otherwise, ignore the IDE related files. E.g. `.idea`  
Install [EditorConfig](http://editorconfig.org/)  
Install Coffee/Less  
[Package Control](https://sublime.wbond.net/installation#st2)  
[Editor Config for Sublime](https://github.com/sindresorhus/editorconfig-sublime)  
[Coffee Syntax for Sublime](https://github.com/jashkenas/coffee-script-tmbundle)  
HTML/CSS Coding Style: follow [Github Coding Sytle](https://github.com/styleguide/css)  
JS/Coffee Coding Sytle: follow [node-style-guide](https://github.com/felixge/node-style-guide)

## Roadmap
### 用户自己的域mapping orgId

### 用户二级域名mapping orgId

### 用户主页

#### 主页显示课程，价格，支付

#### 管理员界面要有支付信息

#### 课程页面显示的老师信息

#### 课程主页显示富文本
#####设计

#### 免费课时预览：把router权限控制放入到controller中

#### 创建小组讨论

#### 3rd login/register

#### 讨论区放到主入口，按课程默认划分板块，同时也可以自己创建板块（与课程无关），老师创建课程的时候自动创建讨论版

##### 富文本中引入音频，tooltip。

#### 课程开课
创建班级，关联课程，from， to，价格。
线下报名的话，管理员手动添加到班级

#### 错题本，错题统计

#### 付费虚拟货币。学生用户在机构下面有余额，用余额购买课程。

## Changelog
### create new branch online_school
### create migration script: migration_20141231.js (when deploy, should run this script)
### add qiniu sync

