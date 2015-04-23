/*!
 * Quillpad API
 *
 * Copyright (c) 2009 Tachyon Technologies. All rights reserved.
 * http://tachyon.in/
 *
 */
if(typeof (dojo)!="undefined"){
dojo.provide("MochiKit.Base");
}
if(typeof (MochiKit)=="undefined"){
MochiKit={};
}
if(typeof (MochiKit.Base)=="undefined"){
MochiKit.Base={};
}
MochiKit.Base.VERSION="1.3.1";
MochiKit.Base.NAME="MochiKit.Base";
MochiKit.Base.update=function(_1,_2){
if(_1===null){
_1={};
}
for(var i=1;i<arguments.length;i++){
var o=arguments[i];
if(typeof (o)!="undefined"&&o!==null){
for(var k in o){
_1[k]=o[k];
}
}
}
return _1;
};
MochiKit.Base.update(MochiKit.Base,{__repr__:function(){
return "["+this.NAME+" "+this.VERSION+"]";
},toString:function(){
return this.__repr__();
},counter:function(n){
if(arguments.length===0){
n=1;
}
return function(){
return n++;
};
},clone:function(_7){
var me=arguments.callee;
if(arguments.length==1){
me.prototype=_7;
return new me();
}
},flattenArguments:function(_9){
var _a=[];
var m=MochiKit.Base;
var _c=m.extend(null,arguments);
while(_c.length){
var o=_c.shift();
if(o&&typeof (o)=="object"&&typeof (o.length)=="number"){
for(var i=o.length-1;i>=0;i--){
_c.unshift(o[i]);
}
}else{
_a.push(o);
}
}
return _a;
},extend:function(_f,obj,_11){
if(!_11){
_11=0;
}
if(obj){
var l=obj.length;
if(typeof (l)!="number"){
if(typeof (MochiKit.Iter)!="undefined"){
obj=MochiKit.Iter.list(obj);
l=obj.length;
}else{
throw new TypeError("Argument not an array-like and MochiKit.Iter not present");
}
}
if(!_f){
_f=[];
}
for(var i=_11;i<l;i++){
_f.push(obj[i]);
}
}
return _f;
},updatetree:function(_14,obj){
if(_14===null){
_14={};
}
for(var i=1;i<arguments.length;i++){
var o=arguments[i];
if(typeof (o)!="undefined"&&o!==null){
for(var k in o){
var v=o[k];
if(typeof (_14[k])=="object"&&typeof (v)=="object"){
arguments.callee(_14[k],v);
}else{
_14[k]=v;
}
}
}
}
return _14;
},setdefault:function(_1a,obj){
if(_1a===null){
_1a={};
}
for(var i=1;i<arguments.length;i++){
var o=arguments[i];
for(var k in o){
if(!(k in _1a)){
_1a[k]=o[k];
}
}
}
return _1a;
},keys:function(obj){
var _20=[];
for(var _21 in obj){
_20.push(_21);
}
return _20;
},items:function(obj){
var _23=[];
var e;
for(var _25 in obj){
var v;
try{
v=obj[_25];
}
catch(e){
continue;
}
_23.push([_25,v]);
}
return _23;
},_newNamedError:function(_27,_28,_29){
_29.prototype=new MochiKit.Base.NamedError(_27.NAME+"."+_28);
_27[_28]=_29;
},operator:{truth:function(a){
return !!a;
},lognot:function(a){
return !a;
},identity:function(a){
return a;
},not:function(a){
return ~a;
},neg:function(a){
return -a;
},add:function(a,b){
return a+b;
},sub:function(a,b){
return a-b;
},div:function(a,b){
return a/b;
},mod:function(a,b){
return a%b;
},mul:function(a,b){
return a*b;
},and:function(a,b){
return a&b;
},or:function(a,b){
return a|b;
},xor:function(a,b){
return a^b;
},lshift:function(a,b){
return a<<b;
},rshift:function(a,b){
return a>>b;
},zrshift:function(a,b){
return a>>>b;
},eq:function(a,b){
return a==b;
},ne:function(a,b){
return a!=b;
},gt:function(a,b){
return a>b;
},ge:function(a,b){
return a>=b;
},lt:function(a,b){
return a<b;
},le:function(a,b){
return a<=b;
},ceq:function(a,b){
return MochiKit.Base.compare(a,b)===0;
},cne:function(a,b){
return MochiKit.Base.compare(a,b)!==0;
},cgt:function(a,b){
return MochiKit.Base.compare(a,b)==1;
},cge:function(a,b){
return MochiKit.Base.compare(a,b)!=-1;
},clt:function(a,b){
return MochiKit.Base.compare(a,b)==-1;
},cle:function(a,b){
return MochiKit.Base.compare(a,b)!=1;
},logand:function(a,b){
return a&&b;
},logor:function(a,b){
return a||b;
},contains:function(a,b){
return b in a;
}},forwardCall:function(_63){
return function(){
return this[_63].apply(this,arguments);
};
},itemgetter:function(_64){
return function(arg){
return arg[_64];
};
},typeMatcher:function(){
var _66={};
for(var i=0;i<arguments.length;i++){
var typ=arguments[i];
_66[typ]=typ;
}
return function(){
for(var i=0;i<arguments.length;i++){
if(!(typeof (arguments[i]) in _66)){
return false;
}
}
return true;
};
},isNull:function(){
for(var i=0;i<arguments.length;i++){
if(arguments[i]!==null){
return false;
}
}
return true;
},isUndefinedOrNull:function(){
for(var i=0;i<arguments.length;i++){
var o=arguments[i];
if(!(typeof (o)=="undefined"||o===null)){
return false;
}
}
return true;
},isEmpty:function(obj){
return !MochiKit.Base.isNotEmpty.apply(this,arguments);
},isNotEmpty:function(obj){
for(var i=0;i<arguments.length;i++){
var o=arguments[i];
if(!(o&&o.length)){
return false;
}
}
return true;
},isArrayLike:function(){
for(var i=0;i<arguments.length;i++){
var o=arguments[i];
var typ=typeof (o);
if((typ!="object"&&!(typ=="function"&&typeof (o.item)=="function"))||o===null||typeof (o.length)!="number"){
return false;
}
}
return true;
},isDateLike:function(){
for(var i=0;i<arguments.length;i++){
var o=arguments[i];
if(typeof (o)!="object"||o===null||typeof (o.getTime)!="function"){
return false;
}
}
return true;
},xmap:function(fn){
if(fn===null){
return MochiKit.Base.extend(null,arguments,1);
}
var _77=[];
for(var i=1;i<arguments.length;i++){
_77.push(fn(arguments[i]));
}
return _77;
},map:function(fn,lst){
var m=MochiKit.Base;
var itr=MochiKit.Iter;
var _7d=m.isArrayLike;
if(arguments.length<=2){
if(!_7d(lst)){
if(itr){
lst=itr.list(lst);
if(fn===null){
return lst;
}
}else{
throw new TypeError("Argument not an array-like and MochiKit.Iter not present");
}
}
if(fn===null){
return m.extend(null,lst);
}
var _7e=[];
for(var i=0;i<lst.length;i++){
_7e.push(fn(lst[i]));
}
return _7e;
}else{
if(fn===null){
fn=Array;
}
var _80=null;
for(i=1;i<arguments.length;i++){
if(!_7d(arguments[i])){
if(itr){
return itr.list(itr.imap.apply(null,arguments));
}else{
throw new TypeError("Argument not an array-like and MochiKit.Iter not present");
}
}
var l=arguments[i].length;
if(_80===null||_80>l){
_80=l;
}
}
_7e=[];
for(i=0;i<_80;i++){
var _82=[];
for(var j=1;j<arguments.length;j++){
_82.push(arguments[j][i]);
}
_7e.push(fn.apply(this,_82));
}
return _7e;
}
},xfilter:function(fn){
var _85=[];
if(fn===null){
fn=MochiKit.Base.operator.truth;
}
for(var i=1;i<arguments.length;i++){
var o=arguments[i];
if(fn(o)){
_85.push(o);
}
}
return _85;
},filter:function(fn,lst,_8a){
var _8b=[];
var m=MochiKit.Base;
if(!m.isArrayLike(lst)){
if(MochiKit.Iter){
lst=MochiKit.Iter.list(lst);
}else{
throw new TypeError("Argument not an array-like and MochiKit.Iter not present");
}
}
if(fn===null){
fn=m.operator.truth;
}
if(typeof (Array.prototype.filter)=="function"){
return Array.prototype.filter.call(lst,fn,_8a);
}else{
if(typeof (_8a)=="undefined"||_8a===null){
for(var i=0;i<lst.length;i++){
var o=lst[i];
if(fn(o)){
_8b.push(o);
}
}
}else{
for(i=0;i<lst.length;i++){
o=lst[i];
if(fn.call(_8a,o)){
_8b.push(o);
}
}
}
}
return _8b;
},_wrapDumbFunction:function(_8f){
return function(){
switch(arguments.length){
case 0:
return _8f();
case 1:
return _8f(arguments[0]);
case 2:
return _8f(arguments[0],arguments[1]);
case 3:
return _8f(arguments[0],arguments[1],arguments[2]);
}
var _90=[];
for(var i=0;i<arguments.length;i++){
_90.push("arguments["+i+"]");
}
return eval("(func("+_90.join(",")+"))");
};
},method:function(_92,_93){
var m=MochiKit.Base;
return m.bind.apply(this,m.extend([_93,_92],arguments,2));
},bind:function(_95,_96){
if(typeof (_95)=="string"){
_95=_96[_95];
}
var _97=_95.im_func;
var _98=_95.im_preargs;
var _99=_95.im_self;
var m=MochiKit.Base;
if(typeof (_95)=="function"&&typeof (_95.apply)=="undefined"){
_95=m._wrapDumbFunction(_95);
}
if(typeof (_97)!="function"){
_97=_95;
}
if(typeof (_96)!="undefined"){
_99=_96;
}
if(typeof (_98)=="undefined"){
_98=[];
}else{
_98=_98.slice();
}
m.extend(_98,arguments,2);
var _9b=function(){
var _9c=arguments;
var me=arguments.callee;
if(me.im_preargs.length>0){
_9c=m.concat(me.im_preargs,_9c);
}
var _9e=me.im_self;
if(!_9e){
_9e=this;
}
return me.im_func.apply(_9e,_9c);
};
_9b.im_self=_99;
_9b.im_func=_97;
_9b.im_preargs=_98;
return _9b;
},bindMethods:function(_9f){
var _a0=MochiKit.Base.bind;
for(var k in _9f){
var _a2=_9f[k];
if(typeof (_a2)=="function"){
_9f[k]=_a0(_a2,_9f);
}
}
},registerComparator:function(_a3,_a4,_a5,_a6){
MochiKit.Base.comparatorRegistry.register(_a3,_a4,_a5,_a6);
},_primitives:{"boolean":true,"string":true,"number":true},compare:function(a,b){
if(a==b){
return 0;
}
var _a9=(typeof (a)=="undefined"||a===null);
var _aa=(typeof (b)=="undefined"||b===null);
if(_a9&&_aa){
return 0;
}else{
if(_a9){
return -1;
}else{
if(_aa){
return 1;
}
}
}
var m=MochiKit.Base;
var _ac=m._primitives;
if(!(typeof (a) in _ac&&typeof (b) in _ac)){
try{
return m.comparatorRegistry.match(a,b);
}
catch(e){
if(e!=m.NotFound){
throw e;
}
}
}
if(a<b){
return -1;
}else{
if(a>b){
return 1;
}
}
var _ad=m.repr;
throw new TypeError(_ad(a)+" and "+_ad(b)+" can not be compared");
},compareDateLike:function(a,b){
return MochiKit.Base.compare(a.getTime(),b.getTime());
},compareArrayLike:function(a,b){
var _b2=MochiKit.Base.compare;
var _b3=a.length;
var _b4=0;
if(_b3>b.length){
_b4=1;
_b3=b.length;
}else{
if(_b3<b.length){
_b4=-1;
}
}
for(var i=0;i<_b3;i++){
var cmp=_b2(a[i],b[i]);
if(cmp){
return cmp;
}
}
return _b4;
},registerRepr:function(_b7,_b8,_b9,_ba){
MochiKit.Base.reprRegistry.register(_b7,_b8,_b9,_ba);
},repr:function(o){
if(typeof (o)=="undefined"){
return "undefined";
}else{
if(o===null){
return "null";
}
}
try{
if(typeof (o.__repr__)=="function"){
return o.__repr__();
}else{
if(typeof (o.repr)=="function"&&o.repr!=arguments.callee){
return o.repr();
}
}
return MochiKit.Base.reprRegistry.match(o);
}
catch(e){
if(typeof (o.NAME)=="string"&&(o.toString==Function.prototype.toString||o.toString==Object.prototype.toString)){
return o.NAME;
}
}
try{
var _bc=(o+"");
}
catch(e){
return "["+typeof (o)+"]";
}
if(typeof (o)=="function"){
o=_bc.replace(/^\s+/,"");
var idx=o.indexOf("{");
if(idx!=-1){
o=o.substr(0,idx)+"{...}";
}
}
return _bc;
},reprArrayLike:function(o){
var m=MochiKit.Base;
return "["+m.map(m.repr,o).join(", ")+"]";
},reprString:function(o){
return ("\""+o.replace(/(["\\])/g,"\\$1")+"\"").replace(/[\f]/g,"\\f").replace(/[\b]/g,"\\b").replace(/[\n]/g,"\\n").replace(/[\t]/g,"\\t").replace(/[\r]/g,"\\r");
},reprNumber:function(o){
return o+"";
},registerJSON:function(_c2,_c3,_c4,_c5){
MochiKit.Base.jsonRegistry.register(_c2,_c3,_c4,_c5);
},evalJSON:function(){
return eval("("+arguments[0]+")");
},serializeJSON:function(o){
var _c7=typeof (o);
if(_c7=="undefined"){
return "undefined";
}else{
if(_c7=="number"||_c7=="boolean"){
return o+"";
}else{
if(o===null){
return "null";
}
}
}
var m=MochiKit.Base;
var _c9=m.reprString;
if(_c7=="string"){
return _c9(o);
}
var me=arguments.callee;
var _cb;
if(typeof (o.__json__)=="function"){
_cb=o.__json__();
if(o!==_cb){
return me(_cb);
}
}
if(typeof (o.json)=="function"){
_cb=o.json();
if(o!==_cb){
return me(_cb);
}
}
if(_c7!="function"&&typeof (o.length)=="number"){
var res=[];
for(var i=0;i<o.length;i++){
var val=me(o[i]);
if(typeof (val)!="string"){
val="undefined";
}
res.push(val);
}
return "["+res.join(", ")+"]";
}
try{
_cb=m.jsonRegistry.match(o);
return me(_cb);
}
catch(e){
if(e!=m.NotFound){
throw e;
}
}
if(_c7=="function"){
return null;
}
res=[];
for(var k in o){
var _d0;
if(typeof (k)=="number"){
_d0="\""+k+"\"";
}else{
if(typeof (k)=="string"){
_d0=_c9(k);
}else{
continue;
}
}
val=me(o[k]);
if(typeof (val)!="string"){
continue;
}
res.push(_d0+":"+val);
}
return "{"+res.join(", ")+"}";
},objEqual:function(a,b){
return (MochiKit.Base.compare(a,b)===0);
},arrayEqual:function(_d3,arr){
if(_d3.length!=arr.length){
return false;
}
return (MochiKit.Base.compare(_d3,arr)===0);
},concat:function(){
var _d5=[];
var _d6=MochiKit.Base.extend;
for(var i=0;i<arguments.length;i++){
_d6(_d5,arguments[i]);
}
return _d5;
},keyComparator:function(key){
var m=MochiKit.Base;
var _da=m.compare;
if(arguments.length==1){
return function(a,b){
return _da(a[key],b[key]);
};
}
var _dd=m.extend(null,arguments);
return function(a,b){
var _e0=0;
for(var i=0;(_e0===0)&&(i<_dd.length);i++){
var key=_dd[i];
_e0=_da(a[key],b[key]);
}
return _e0;
};
},reverseKeyComparator:function(key){
var _e4=MochiKit.Base.keyComparator.apply(this,arguments);
return function(a,b){
return _e4(b,a);
};
},partial:function(_e7){
var m=MochiKit.Base;
return m.bind.apply(this,m.extend([_e7,undefined],arguments,1));
},listMinMax:function(_e9,lst){
if(lst.length===0){
return null;
}
var cur=lst[0];
var _ec=MochiKit.Base.compare;
for(var i=1;i<lst.length;i++){
var o=lst[i];
if(_ec(o,cur)==_e9){
cur=o;
}
}
return cur;
},objMax:function(){
return MochiKit.Base.listMinMax(1,arguments);
},objMin:function(){
return MochiKit.Base.listMinMax(-1,arguments);
},findIdentical:function(lst,_f0,_f1,end){
if(typeof (end)=="undefined"||end===null){
end=lst.length;
}
for(var i=(_f1||0);i<end;i++){
if(lst[i]===_f0){
return i;
}
}
return -1;
},findValue:function(lst,_f5,_f6,end){
if(typeof (end)=="undefined"||end===null){
end=lst.length;
}
var cmp=MochiKit.Base.compare;
for(var i=(_f6||0);i<end;i++){
if(cmp(lst[i],_f5)===0){
return i;
}
}
return -1;
},nodeWalk:function(_fa,_fb){
var _fc=[_fa];
var _fd=MochiKit.Base.extend;
while(_fc.length){
var res=_fb(_fc.shift());
if(res){
_fd(_fc,res);
}
}
},nameFunctions:function(_ff){
var base=_ff.NAME;
if(typeof (base)=="undefined"){
base="";
}else{
base=base+".";
}
for(var name in _ff){
var o=_ff[name];
if(typeof (o)=="function"&&typeof (o.NAME)=="undefined"){
try{
o.NAME=base+name;
}
catch(e){
}
}
}
},queryString:function(_103,_104){
if(typeof (MochiKit.DOM)!="undefined"&&arguments.length==1&&(typeof (_103)=="string"||(typeof (_103.nodeType)!="undefined"&&_103.nodeType>0))){
var kv=MochiKit.DOM.formContents(_103);
_103=kv[0];
_104=kv[1];
}else{
if(arguments.length==1){
var o=_103;
_103=[];
_104=[];
for(var k in o){
var v=o[k];
if(typeof (v)!="function"){
_103.push(k);
_104.push(v);
}
}
}
}
var rval=[];
var len=Math.min(_103.length,_104.length);
var _10b=MochiKit.Base.urlEncode;
for(var i=0;i<len;i++){
v=_104[i];
if(typeof (v)!="undefined"&&v!==null){
rval.push(_10b(_103[i])+"="+_10b(v));
}
}
return rval.join("&");
},parseQueryString:function(_10d,_10e){
var _10f=_10d.replace(/\+/g,"%20").split("&");
var o={};
var _111;
if(typeof (decodeURIComponent)!="undefined"){
_111=decodeURIComponent;
}else{
_111=unescape;
}
if(_10e){
for(var i=0;i<_10f.length;i++){
var pair=_10f[i].split("=");
var name=_111(pair[0]);
var arr=o[name];
if(!(arr instanceof Array)){
arr=[];
o[name]=arr;
}
arr.push(_111(pair[1]));
}
}else{
for(i=0;i<_10f.length;i++){
pair=_10f[i].split("=");
o[_111(pair[0])]=_111(pair[1]);
}
}
return o;
}});
MochiKit.Base.AdapterRegistry=function(){
this.pairs=[];
};
MochiKit.Base.AdapterRegistry.prototype={register:function(name,_117,wrap,_119){
if(_119){
this.pairs.unshift([name,_117,wrap]);
}else{
this.pairs.push([name,_117,wrap]);
}
},match:function(){
for(var i=0;i<this.pairs.length;i++){
var pair=this.pairs[i];
if(pair[1].apply(this,arguments)){
return pair[2].apply(this,arguments);
}
}
throw MochiKit.Base.NotFound;
},unregister:function(name){
for(var i=0;i<this.pairs.length;i++){
var pair=this.pairs[i];
if(pair[0]==name){
this.pairs.splice(i,1);
return true;
}
}
return false;
}};
MochiKit.Base.EXPORT=["counter","clone","extend","update","updatetree","setdefault","keys","items","NamedError","operator","forwardCall","itemgetter","typeMatcher","isCallable","isUndefined","isUndefinedOrNull","isNull","isEmpty","isNotEmpty","isArrayLike","isDateLike","xmap","map","xfilter","filter","bind","bindMethods","NotFound","AdapterRegistry","registerComparator","compare","registerRepr","repr","objEqual","arrayEqual","concat","keyComparator","reverseKeyComparator","partial","merge","listMinMax","listMax","listMin","objMax","objMin","nodeWalk","zip","urlEncode","queryString","serializeJSON","registerJSON","evalJSON","parseQueryString","findValue","findIdentical","flattenArguments","method"];
MochiKit.Base.EXPORT_OK=["nameFunctions","comparatorRegistry","reprRegistry","jsonRegistry","compareDateLike","compareArrayLike","reprArrayLike","reprString","reprNumber"];
MochiKit.Base._exportSymbols=function(_11f,_120){
if(typeof (MochiKit.__export__)=="undefined"){
MochiKit.__export__=(MochiKit.__compat__||(typeof (JSAN)=="undefined"&&typeof (dojo)=="undefined"));
}
if(!MochiKit.__export__){
return;
}
var all=_120.EXPORT_TAGS[":all"];
for(var i=0;i<all.length;i++){
_11f[all[i]]=_120[all[i]];
}
};
MochiKit.Base.__new__=function(){
var m=this;
m.forward=m.forwardCall;
m.find=m.findValue;
if(typeof (encodeURIComponent)!="undefined"){
m.urlEncode=function(_124){
return encodeURIComponent(_124).replace(/\'/g,"%27");
};
}else{
m.urlEncode=function(_125){
return escape(_125).replace(/\+/g,"%2B").replace(/\"/g,"%22").rval.replace(/\'/g,"%27");
};
}
m.NamedError=function(name){
this.message=name;
this.name=name;
};
m.NamedError.prototype=new Error();
m.update(m.NamedError.prototype,{repr:function(){
if(this.message&&this.message!=this.name){
return this.name+"("+m.repr(this.message)+")";
}else{
return this.name+"()";
}
},toString:m.forwardCall("repr")});
m.NotFound=new m.NamedError("MochiKit.Base.NotFound");
m.listMax=m.partial(m.listMinMax,1);
m.listMin=m.partial(m.listMinMax,-1);
m.isCallable=m.typeMatcher("function");
m.isUndefined=m.typeMatcher("undefined");
m.merge=m.partial(m.update,null);
m.zip=m.partial(m.map,null);
m.comparatorRegistry=new m.AdapterRegistry();
m.registerComparator("dateLike",m.isDateLike,m.compareDateLike);
m.registerComparator("arrayLike",m.isArrayLike,m.compareArrayLike);
m.reprRegistry=new m.AdapterRegistry();
m.registerRepr("arrayLike",m.isArrayLike,m.reprArrayLike);
m.registerRepr("string",m.typeMatcher("string"),m.reprString);
m.registerRepr("numbers",m.typeMatcher("number","boolean"),m.reprNumber);
m.jsonRegistry=new m.AdapterRegistry();
var all=m.concat(m.EXPORT,m.EXPORT_OK);
m.EXPORT_TAGS={":common":m.concat(m.EXPORT_OK),":all":all};
m.nameFunctions(this);
};
MochiKit.Base.__new__();
if(!MochiKit.__compat__){
compare=MochiKit.Base.compare;
}
MochiKit.Base._exportSymbols(this,MochiKit.Base);
if(typeof (dojo)!="undefined"){
dojo.provide("MochiKit.Iter");
dojo.require("MochiKit.Base");
}
if(typeof (JSAN)!="undefined"){
JSAN.use("MochiKit.Base",[]);
}
try{
if(typeof (MochiKit.Base)=="undefined"){
throw "";
}
}
catch(e){
throw "MochiKit.Iter depends on MochiKit.Base!";
}
if(typeof (MochiKit.Iter)=="undefined"){
MochiKit.Iter={};
}
MochiKit.Iter.NAME="MochiKit.Iter";
MochiKit.Iter.VERSION="1.3.1";
MochiKit.Base.update(MochiKit.Iter,{__repr__:function(){
return "["+this.NAME+" "+this.VERSION+"]";
},toString:function(){
return this.__repr__();
},registerIteratorFactory:function(name,_129,_12a,_12b){
MochiKit.Iter.iteratorRegistry.register(name,_129,_12a,_12b);
},iter:function(_12c,_12d){
var self=MochiKit.Iter;
if(arguments.length==2){
return self.takewhile(function(a){
return a!=_12d;
},_12c);
}
if(typeof (_12c.next)=="function"){
return _12c;
}else{
if(typeof (_12c.iter)=="function"){
return _12c.iter();
}
}
try{
return self.iteratorRegistry.match(_12c);
}
catch(e){
var m=MochiKit.Base;
if(e==m.NotFound){
e=new TypeError(typeof (_12c)+": "+m.repr(_12c)+" is not iterable");
}
throw e;
}
},count:function(n){
if(!n){
n=0;
}
var m=MochiKit.Base;
return {repr:function(){
return "count("+n+")";
},toString:m.forwardCall("repr"),next:m.counter(n)};
},cycle:function(p){
var self=MochiKit.Iter;
var m=MochiKit.Base;
var lst=[];
var _137=self.iter(p);
return {repr:function(){
return "cycle(...)";
},toString:m.forwardCall("repr"),next:function(){
try{
var rval=_137.next();
lst.push(rval);
return rval;
}
catch(e){
if(e!=self.StopIteration){
throw e;
}
if(lst.length===0){
this.next=function(){
throw self.StopIteration;
};
}else{
var i=-1;
this.next=function(){
i=(i+1)%lst.length;
return lst[i];
};
}
return this.next();
}
}};
},repeat:function(elem,n){
var m=MochiKit.Base;
if(typeof (n)=="undefined"){
return {repr:function(){
return "repeat("+m.repr(elem)+")";
},toString:m.forwardCall("repr"),next:function(){
return elem;
}};
}
return {repr:function(){
return "repeat("+m.repr(elem)+", "+n+")";
},toString:m.forwardCall("repr"),next:function(){
if(n<=0){
throw MochiKit.Iter.StopIteration;
}
n-=1;
return elem;
}};
},next:function(_13d){
return _13d.next();
},izip:function(p,q){
var m=MochiKit.Base;
var next=MochiKit.Iter.next;
var _142=m.map(iter,arguments);
return {repr:function(){
return "izip(...)";
},toString:m.forwardCall("repr"),next:function(){
return m.map(next,_142);
}};
},ifilter:function(pred,seq){
var m=MochiKit.Base;
seq=MochiKit.Iter.iter(seq);
if(pred===null){
pred=m.operator.truth;
}
return {repr:function(){
return "ifilter(...)";
},toString:m.forwardCall("repr"),next:function(){
while(true){
var rval=seq.next();
if(pred(rval)){
return rval;
}
}
return undefined;
}};
},ifilterfalse:function(pred,seq){
var m=MochiKit.Base;
seq=MochiKit.Iter.iter(seq);
if(pred===null){
pred=m.operator.truth;
}
return {repr:function(){
return "ifilterfalse(...)";
},toString:m.forwardCall("repr"),next:function(){
while(true){
var rval=seq.next();
if(!pred(rval)){
return rval;
}
}
return undefined;
}};
},islice:function(seq){
var self=MochiKit.Iter;
var m=MochiKit.Base;
seq=self.iter(seq);
var _14e=0;
var stop=0;
var step=1;
var i=-1;
if(arguments.length==2){
stop=arguments[1];
}else{
if(arguments.length==3){
_14e=arguments[1];
stop=arguments[2];
}else{
_14e=arguments[1];
stop=arguments[2];
step=arguments[3];
}
}
return {repr:function(){
return "islice("+["...",_14e,stop,step].join(", ")+")";
},toString:m.forwardCall("repr"),next:function(){
var rval;
while(i<_14e){
rval=seq.next();
i++;
}
if(_14e>=stop){
throw self.StopIteration;
}
_14e+=step;
return rval;
}};
},imap:function(fun,p,q){
var m=MochiKit.Base;
var self=MochiKit.Iter;
var _158=m.map(self.iter,m.extend(null,arguments,1));
var map=m.map;
var next=self.next;
return {repr:function(){
return "imap(...)";
},toString:m.forwardCall("repr"),next:function(){
return fun.apply(this,map(next,_158));
}};
},applymap:function(fun,seq,self){
seq=MochiKit.Iter.iter(seq);
var m=MochiKit.Base;
return {repr:function(){
return "applymap(...)";
},toString:m.forwardCall("repr"),next:function(){
return fun.apply(self,seq.next());
}};
},chain:function(p,q){
var self=MochiKit.Iter;
var m=MochiKit.Base;
if(arguments.length==1){
return self.iter(arguments[0]);
}
var _163=m.map(self.iter,arguments);
return {repr:function(){
return "chain(...)";
},toString:m.forwardCall("repr"),next:function(){
while(_163.length>1){
try{
return _163[0].next();
}
catch(e){
if(e!=self.StopIteration){
throw e;
}
_163.shift();
}
}
if(_163.length==1){
var arg=_163.shift();
this.next=m.bind("next",arg);
return this.next();
}
throw self.StopIteration;
}};
},takewhile:function(pred,seq){
var self=MochiKit.Iter;
seq=self.iter(seq);
return {repr:function(){
return "takewhile(...)";
},toString:MochiKit.Base.forwardCall("repr"),next:function(){
var rval=seq.next();
if(!pred(rval)){
this.next=function(){
throw self.StopIteration;
};
this.next();
}
return rval;
}};
},dropwhile:function(pred,seq){
seq=MochiKit.Iter.iter(seq);
var m=MochiKit.Base;
var bind=m.bind;
return {"repr":function(){
return "dropwhile(...)";
},"toString":m.forwardCall("repr"),"next":function(){
while(true){
var rval=seq.next();
if(!pred(rval)){
break;
}
}
this.next=bind("next",seq);
return rval;
}};
},_tee:function(_16e,sync,_170){
sync.pos[_16e]=-1;
var m=MochiKit.Base;
var _172=m.listMin;
return {repr:function(){
return "tee("+_16e+", ...)";
},toString:m.forwardCall("repr"),next:function(){
var rval;
var i=sync.pos[_16e];
if(i==sync.max){
rval=_170.next();
sync.deque.push(rval);
sync.max+=1;
sync.pos[_16e]+=1;
}else{
rval=sync.deque[i-sync.min];
sync.pos[_16e]+=1;
if(i==sync.min&&_172(sync.pos)!=sync.min){
sync.min+=1;
sync.deque.shift();
}
}
return rval;
}};
},tee:function(_175,n){
var rval=[];
var sync={"pos":[],"deque":[],"max":-1,"min":-1};
if(arguments.length==1){
n=2;
}
var self=MochiKit.Iter;
_175=self.iter(_175);
var _tee=self._tee;
for(var i=0;i<n;i++){
rval.push(_tee(i,sync,_175));
}
return rval;
},list:function(_17c){
var m=MochiKit.Base;
if(typeof (_17c.slice)=="function"){
return _17c.slice();
}else{
if(m.isArrayLike(_17c)){
return m.concat(_17c);
}
}
var self=MochiKit.Iter;
_17c=self.iter(_17c);
var rval=[];
try{
while(true){
rval.push(_17c.next());
}
}
catch(e){
if(e!=self.StopIteration){
throw e;
}
return rval;
}
return undefined;
},reduce:function(fn,_181,_182){
var i=0;
var x=_182;
var self=MochiKit.Iter;
_181=self.iter(_181);
if(arguments.length<3){
try{
x=_181.next();
}
catch(e){
if(e==self.StopIteration){
e=new TypeError("reduce() of empty sequence with no initial value");
}
throw e;
}
i++;
}
try{
while(true){
x=fn(x,_181.next());
}
}
catch(e){
if(e!=self.StopIteration){
throw e;
}
}
return x;
},range:function(){
var _186=0;
var stop=0;
var step=1;
if(arguments.length==1){
stop=arguments[0];
}else{
if(arguments.length==2){
_186=arguments[0];
stop=arguments[1];
}else{
if(arguments.length==3){
_186=arguments[0];
stop=arguments[1];
step=arguments[2];
}else{
throw new TypeError("range() takes 1, 2, or 3 arguments!");
}
}
}
if(step===0){
throw new TypeError("range() step must not be 0");
}
return {next:function(){
if((step>0&&_186>=stop)||(step<0&&_186<=stop)){
throw MochiKit.Iter.StopIteration;
}
var rval=_186;
_186+=step;
return rval;
},repr:function(){
return "range("+[_186,stop,step].join(", ")+")";
},toString:MochiKit.Base.forwardCall("repr")};
},sum:function(_18a,_18b){
var x=_18b||0;
var self=MochiKit.Iter;
_18a=self.iter(_18a);
try{
while(true){
x+=_18a.next();
}
}
catch(e){
if(e!=self.StopIteration){
throw e;
}
}
return x;
},exhaust:function(_18e){
var self=MochiKit.Iter;
_18e=self.iter(_18e);
try{
while(true){
_18e.next();
}
}
catch(e){
if(e!=self.StopIteration){
throw e;
}
}
},forEach:function(_190,func,self){
var m=MochiKit.Base;
if(arguments.length>2){
func=m.bind(func,self);
}
if(m.isArrayLike(_190)){
try{
for(var i=0;i<_190.length;i++){
func(_190[i]);
}
}
catch(e){
if(e!=MochiKit.Iter.StopIteration){
throw e;
}
}
}else{
self=MochiKit.Iter;
self.exhaust(self.imap(func,_190));
}
},every:function(_195,func){
var self=MochiKit.Iter;
try{
self.ifilterfalse(func,_195).next();
return false;
}
catch(e){
if(e!=self.StopIteration){
throw e;
}
return true;
}
},sorted:function(_198,cmp){
var rval=MochiKit.Iter.list(_198);
if(arguments.length==1){
cmp=MochiKit.Base.compare;
}
rval.sort(cmp);
return rval;
},reversed:function(_19b){
var rval=MochiKit.Iter.list(_19b);
rval.reverse();
return rval;
},some:function(_19d,func){
var self=MochiKit.Iter;
try{
self.ifilter(func,_19d).next();
return true;
}
catch(e){
if(e!=self.StopIteration){
throw e;
}
return false;
}
},iextend:function(lst,_1a1){
if(MochiKit.Base.isArrayLike(_1a1)){
for(var i=0;i<_1a1.length;i++){
lst.push(_1a1[i]);
}
}else{
var self=MochiKit.Iter;
_1a1=self.iter(_1a1);
try{
while(true){
lst.push(_1a1.next());
}
}
catch(e){
if(e!=self.StopIteration){
throw e;
}
}
}
return lst;
},groupby:function(_1a4,_1a5){
var m=MochiKit.Base;
var self=MochiKit.Iter;
if(arguments.length<2){
_1a5=m.operator.identity;
}
_1a4=self.iter(_1a4);
var pk=undefined;
var k=undefined;
var v;
function fetch(){
v=_1a4.next();
k=_1a5(v);
}
function eat(){
var ret=v;
v=undefined;
return ret;
}
var _1ac=true;
return {repr:function(){
return "groupby(...)";
},next:function(){
while(k==pk){
fetch();
if(_1ac){
_1ac=false;
break;
}
}
pk=k;
return [k,{next:function(){
if(v==undefined){
fetch();
}
if(k!=pk){
throw self.StopIteration;
}
return eat();
}}];
}};
},groupby_as_array:function(_1ad,_1ae){
var m=MochiKit.Base;
var self=MochiKit.Iter;
if(arguments.length<2){
_1ae=m.operator.identity;
}
_1ad=self.iter(_1ad);
var _1b1=[];
var _1b2=true;
var _1b3;
while(true){
try{
var _1b4=_1ad.next();
var key=_1ae(_1b4);
}
catch(e){
if(e==self.StopIteration){
break;
}
throw e;
}
if(_1b2||key!=_1b3){
var _1b6=[];
_1b1.push([key,_1b6]);
}
_1b6.push(_1b4);
_1b2=false;
_1b3=key;
}
return _1b1;
},arrayLikeIter:function(_1b7){
var i=0;
return {repr:function(){
return "arrayLikeIter(...)";
},toString:MochiKit.Base.forwardCall("repr"),next:function(){
if(i>=_1b7.length){
throw MochiKit.Iter.StopIteration;
}
return _1b7[i++];
}};
},hasIterateNext:function(_1b9){
return (_1b9&&typeof (_1b9.iterateNext)=="function");
},iterateNextIter:function(_1ba){
return {repr:function(){
return "iterateNextIter(...)";
},toString:MochiKit.Base.forwardCall("repr"),next:function(){
var rval=_1ba.iterateNext();
if(rval===null||rval===undefined){
throw MochiKit.Iter.StopIteration;
}
return rval;
}};
}});
MochiKit.Iter.EXPORT_OK=["iteratorRegistry","arrayLikeIter","hasIterateNext","iterateNextIter",];
MochiKit.Iter.EXPORT=["StopIteration","registerIteratorFactory","iter","count","cycle","repeat","next","izip","ifilter","ifilterfalse","islice","imap","applymap","chain","takewhile","dropwhile","tee","list","reduce","range","sum","exhaust","forEach","every","sorted","reversed","some","iextend","groupby","groupby_as_array"];
MochiKit.Iter.__new__=function(){
var m=MochiKit.Base;
this.StopIteration=new m.NamedError("StopIteration");
this.iteratorRegistry=new m.AdapterRegistry();
this.registerIteratorFactory("arrayLike",m.isArrayLike,this.arrayLikeIter);
this.registerIteratorFactory("iterateNext",this.hasIterateNext,this.iterateNextIter);
this.EXPORT_TAGS={":common":this.EXPORT,":all":m.concat(this.EXPORT,this.EXPORT_OK)};
m.nameFunctions(this);
};
MochiKit.Iter.__new__();
if(!MochiKit.__compat__){
reduce=MochiKit.Iter.reduce;
}
MochiKit.Base._exportSymbols(this,MochiKit.Iter);
if(typeof (dojo)!="undefined"){
dojo.provide("MochiKit.DOM");
dojo.require("MochiKit.Iter");
}
if(typeof (JSAN)!="undefined"){
JSAN.use("MochiKit.Iter",[]);
}
try{
if(typeof (MochiKit.Iter)=="undefined"){
throw "";
}
}
catch(e){
throw "MochiKit.DOM depends on MochiKit.Iter!";
}
if(typeof (MochiKit.DOM)=="undefined"){
MochiKit.DOM={};
}
MochiKit.DOM.NAME="MochiKit.DOM";
MochiKit.DOM.VERSION="1.3.1";
MochiKit.DOM.__repr__=function(){
return "["+this.NAME+" "+this.VERSION+"]";
};
MochiKit.DOM.toString=function(){
return this.__repr__();
};
MochiKit.DOM.EXPORT=["formContents","currentWindow","currentDocument","withWindow","withDocument","registerDOMConverter","coerceToDOM","createDOM","createDOMFunc","getNodeAttribute","setNodeAttribute","updateNodeAttributes","appendChildNodes","replaceChildNodes","removeElement","swapDOM","BUTTON","TT","PRE","H1","H2","H3","BR","CANVAS","HR","LABEL","TEXTAREA","FORM","STRONG","SELECT","OPTION","OPTGROUP","LEGEND","FIELDSET","P","UL","OL","LI","TD","TR","THEAD","TBODY","TFOOT","TABLE","TH","INPUT","SPAN","A","DIV","IMG","getElement","computedStyle","getElementsByTagAndClassName","addToCallStack","addLoadEvent","focusOnLoad","setElementClass","toggleElementClass","addElementClass","removeElementClass","swapElementClass","hasElementClass","escapeHTML","toHTML","emitHTML","setDisplayForElement","hideElement","showElement","scrapeText","elementDimensions","elementPosition","setElementDimensions","setElementPosition","getViewportDimensions","setOpacity"];
MochiKit.DOM.EXPORT_OK=["domConverters"];
MochiKit.DOM.Dimensions=function(w,h){
this.w=w;
this.h=h;
};
MochiKit.DOM.Dimensions.prototype.repr=function(){
var repr=MochiKit.Base.repr;
return "{w: "+repr(this.w)+", h: "+repr(this.h)+"}";
};
MochiKit.DOM.Coordinates=function(x,y){
this.x=x;
this.y=y;
};
MochiKit.DOM.Coordinates.prototype.repr=function(){
var repr=MochiKit.Base.repr;
return "{x: "+repr(this.x)+", y: "+repr(this.y)+"}";
};
MochiKit.DOM.Coordinates.prototype.toString=function(){
return this.repr();
};
MochiKit.Base.update(MochiKit.DOM,{setOpacity:function(elem,o){
elem=MochiKit.DOM.getElement(elem);
MochiKit.DOM.updateNodeAttributes(elem,{"style":{"opacity":o,"-moz-opacity":o,"-khtml-opacity":o,"filter":" alpha(opacity="+(o*100)+")"}});
},getViewportDimensions:function(){
var d=new MochiKit.DOM.Dimensions();
var w=MochiKit.DOM._window;
var b=MochiKit.DOM._document.body;
if(w.innerWidth){
d.w=w.innerWidth;
d.h=w.innerHeight;
}else{
if(b.parentElement.clientWidth){
d.w=b.parentElement.clientWidth;
d.h=b.parentElement.clientHeight;
}else{
if(b&&b.clientWidth){
d.w=b.clientWidth;
d.h=b.clientHeight;
}
}
}
return d;
},elementDimensions:function(elem){
var self=MochiKit.DOM;
if(typeof (elem.w)=="number"||typeof (elem.h)=="number"){
return new self.Dimensions(elem.w||0,elem.h||0);
}
elem=self.getElement(elem);
if(!elem){
return undefined;
}
if(self.computedStyle(elem,"display")!="none"){
return new self.Dimensions(elem.offsetWidth||0,elem.offsetHeight||0);
}
var s=elem.style;
var _1cb=s.visibility;
var _1cc=s.position;
s.visibility="hidden";
s.position="absolute";
s.display="";
var _1cd=elem.offsetWidth;
var _1ce=elem.offsetHeight;
s.display="none";
s.position=_1cc;
s.visibility=_1cb;
return new self.Dimensions(_1cd,_1ce);
},elementPosition:function(elem,_1d0){
var self=MochiKit.DOM;
elem=self.getElement(elem);
if(!elem){
return undefined;
}
var c=new self.Coordinates(0,0);
if(elem.x&&elem.y){
c.x+=elem.x||0;
c.y+=elem.y||0;
return c;
}else{
if(elem.parentNode===null||self.computedStyle(elem,"display")=="none"){
return undefined;
}
}
var box=null;
var _1d4=null;
var d=MochiKit.DOM._document;
var de=d.documentElement;
var b=d.body;
if(elem.getBoundingClientRect){
box=elem.getBoundingClientRect();
c.x+=box.left+(de.scrollLeft||b.scrollLeft)-(de.clientLeft||b.clientLeft);
c.y+=box.top+(de.scrollTop||b.scrollTop)-(de.clientTop||b.clientTop);
}else{
if(d.getBoxObjectFor){
box=d.getBoxObjectFor(elem);
c.x+=box.x;
c.y+=box.y;
}else{
if(elem.offsetParent){
c.x+=elem.offsetLeft;
c.y+=elem.offsetTop;
_1d4=elem.offsetParent;
if(_1d4!=elem){
while(_1d4){
c.x+=_1d4.offsetLeft;
c.y+=_1d4.offsetTop;
_1d4=_1d4.offsetParent;
}
}
var ua=navigator.userAgent.toLowerCase();
if((typeof (opera)!="undefined"&&parseFloat(opera.version())<9)||(ua.indexOf("safari")!=-1&&self.computedStyle(elem,"position")=="absolute")){
c.x-=b.offsetLeft;
c.y-=b.offsetTop;
}
}
}
}
if(typeof (_1d0)!="undefined"){
_1d0=arguments.callee(_1d0);
if(_1d0){
c.x-=(_1d0.x||0);
c.y-=(_1d0.y||0);
}
}
if(elem.parentNode){
_1d4=elem.parentNode;
}else{
_1d4=null;
}
while(_1d4&&_1d4.tagName!="BODY"&&_1d4.tagName!="HTML"){
c.x-=_1d4.scrollLeft;
c.y-=_1d4.scrollTop;
if(_1d4.parentNode){
_1d4=_1d4.parentNode;
}else{
_1d4=null;
}
}
return c;
},setElementDimensions:function(elem,_1da,_1db){
elem=MochiKit.DOM.getElement(elem);
if(typeof (_1db)=="undefined"){
_1db="px";
}
MochiKit.DOM.updateNodeAttributes(elem,{"style":{"width":_1da.w+_1db,"height":_1da.h+_1db}});
},setElementPosition:function(elem,_1dd,_1de){
elem=MochiKit.DOM.getElement(elem);
if(typeof (_1de)=="undefined"){
_1de="px";
}
MochiKit.DOM.updateNodeAttributes(elem,{"style":{"left":_1dd.x+_1de,"top":_1dd.y+_1de}});
},currentWindow:function(){
return MochiKit.DOM._window;
},currentDocument:function(){
return MochiKit.DOM._document;
},withWindow:function(win,func){
var self=MochiKit.DOM;
var _1e2=self._document;
var _1e3=self._win;
var rval;
try{
self._window=win;
self._document=win.document;
rval=func();
}
catch(e){
self._window=_1e3;
self._document=_1e2;
throw e;
}
self._window=_1e3;
self._document=_1e2;
return rval;
},formContents:function(elem){
var _1e6=[];
var _1e7=[];
var m=MochiKit.Base;
var self=MochiKit.DOM;
if(typeof (elem)=="undefined"||elem===null){
elem=self._document;
}else{
elem=self.getElement(elem);
}
m.nodeWalk(elem,function(elem){
var name=elem.name;
if(m.isNotEmpty(name)){
var _1ec=elem.nodeName;
if(_1ec=="INPUT"&&(elem.type=="radio"||elem.type=="checkbox")&&!elem.checked){
return null;
}
if(_1ec=="SELECT"){
if(elem.selectedIndex>=0){
var opt=elem.options[elem.selectedIndex];
_1e6.push(name);
_1e7.push((opt.value)?opt.value:opt.text);
return null;
}
_1e6.push(name);
_1e7.push("");
return null;
}
if(_1ec=="FORM"||_1ec=="P"||_1ec=="SPAN"||_1ec=="DIV"){
return elem.childNodes;
}
_1e6.push(name);
_1e7.push(elem.value||"");
return null;
}
return elem.childNodes;
});
return [_1e6,_1e7];
},withDocument:function(doc,func){
var self=MochiKit.DOM;
var _1f1=self._document;
var rval;
try{
self._document=doc;
rval=func();
}
catch(e){
self._document=_1f1;
throw e;
}
self._document=_1f1;
return rval;
},registerDOMConverter:function(name,_1f4,wrap,_1f6){
MochiKit.DOM.domConverters.register(name,_1f4,wrap,_1f6);
},coerceToDOM:function(node,ctx){
var im=MochiKit.Iter;
var self=MochiKit.DOM;
var iter=im.iter;
var _1fc=im.repeat;
var imap=im.imap;
var _1fe=self.domConverters;
var _1ff=self.coerceToDOM;
var _200=MochiKit.Base.NotFound;
while(true){
if(typeof (node)=="undefined"||node===null){
return null;
}
if(typeof (node.nodeType)!="undefined"&&node.nodeType>0){
return node;
}
if(typeof (node)=="number"||typeof (node)=="boolean"){
node=node.toString();
}
if(typeof (node)=="string"){
return self._document.createTextNode(node);
}
if(typeof (node.toDOM)=="function"){
node=node.toDOM(ctx);
continue;
}
if(typeof (node)=="function"){
node=node(ctx);
continue;
}
var _201=null;
try{
_201=iter(node);
}
catch(e){
}
if(_201){
return imap(_1ff,_201,_1fc(ctx));
}
try{
node=_1fe.match(node,ctx);
continue;
}
catch(e){
if(e!=_200){
throw e;
}
}
return self._document.createTextNode(node.toString());
}
return undefined;
},setNodeAttribute:function(node,attr,_204){
var o={};
o[attr]=_204;
try{
return MochiKit.DOM.updateNodeAttributes(node,o);
}
catch(e){
}
return null;
},getNodeAttribute:function(node,attr){
var self=MochiKit.DOM;
var _209=self.attributeArray.renames[attr];
node=self.getElement(node);
try{
if(_209){
return node[_209];
}
return node.getAttribute(attr);
}
catch(e){
}
return null;
},updateNodeAttributes:function(node,_20b){
var elem=node;
var self=MochiKit.DOM;
if(typeof (node)=="string"){
elem=self.getElement(node);
}
if(_20b){
var _20e=MochiKit.Base.updatetree;
if(self.attributeArray.compliant){
for(var k in _20b){
var v=_20b[k];
if(typeof (v)=="object"&&typeof (elem[k])=="object"){
_20e(elem[k],v);
}else{
if(k.substring(0,2)=="on"){
if(typeof (v)=="string"){
v=new Function(v);
}
elem[k]=v;
}else{
elem.setAttribute(k,v);
}
}
}
}else{
var _211=self.attributeArray.renames;
for(k in _20b){
v=_20b[k];
var _212=_211[k];
if(k=="style"&&typeof (v)=="string"){
elem.style.cssText=v;
}else{
if(typeof (_212)=="string"){
elem[_212]=v;
}else{
if(typeof (elem[k])=="object"&&typeof (v)=="object"){
_20e(elem[k],v);
}else{
if(k.substring(0,2)=="on"){
if(typeof (v)=="string"){
v=new Function(v);
}
elem[k]=v;
}else{
elem.setAttribute(k,v);
}
}
}
}
}
}
}
return elem;
},appendChildNodes:function(node){
var elem=node;
var self=MochiKit.DOM;
if(typeof (node)=="string"){
elem=self.getElement(node);
}
var _216=[self.coerceToDOM(MochiKit.Base.extend(null,arguments,1),elem)];
var _217=MochiKit.Base.concat;
while(_216.length){
var n=_216.shift();
if(typeof (n)=="undefined"||n===null){
}else{
if(typeof (n.nodeType)=="number"){
elem.appendChild(n);
}else{
_216=_217(n,_216);
}
}
}
return elem;
},replaceChildNodes:function(node){
var elem=node;
var self=MochiKit.DOM;
if(typeof (node)=="string"){
elem=self.getElement(node);
arguments[0]=elem;
}
var _21c;
while((_21c=elem.firstChild)){
elem.removeChild(_21c);
}
if(arguments.length<2){
return elem;
}else{
return self.appendChildNodes.apply(this,arguments);
}
},createDOM:function(name,_21e){
var elem;
var self=MochiKit.DOM;
var m=MochiKit.Base;
if(typeof (_21e)=="string"||typeof (_21e)=="number"){
var args=m.extend([name,null],arguments,1);
return arguments.callee.apply(this,args);
}
if(typeof (name)=="string"){
if(_21e&&"name" in _21e&&!self.attributeArray.compliant){
name=("<"+name+" name=\""+self.escapeHTML(_21e.name)+"\">");
}
elem=self._document.createElement(name);
}else{
elem=name;
}
if(_21e){
self.updateNodeAttributes(elem,_21e);
}
if(arguments.length<=2){
return elem;
}else{
var args=m.extend([elem],arguments,2);
return self.appendChildNodes.apply(this,args);
}
},createDOMFunc:function(){
var m=MochiKit.Base;
return m.partial.apply(this,m.extend([MochiKit.DOM.createDOM],arguments));
},swapDOM:function(dest,src){
var self=MochiKit.DOM;
dest=self.getElement(dest);
var _227=dest.parentNode;
if(src){
src=self.getElement(src);
_227.replaceChild(src,dest);
}else{
_227.removeChild(dest);
}
return src;
},getElement:function(id){
var self=MochiKit.DOM;
if(arguments.length==1){
return ((typeof (id)=="string")?self._document.getElementById(id):id);
}else{
return MochiKit.Base.map(self.getElement,arguments);
}
},computedStyle:function(_22a,_22b,_22c){
if(arguments.length==2){
_22c=_22b;
}
var self=MochiKit.DOM;
var el=self.getElement(_22a);
var _22f=self._document;
if(!el||el==_22f){
return undefined;
}
if(el.currentStyle){
return el.currentStyle[_22b];
}
if(typeof (_22f.defaultView)=="undefined"){
return undefined;
}
if(_22f.defaultView===null){
return undefined;
}
var _230=_22f.defaultView.getComputedStyle(el,null);
if(typeof (_230)=="undefined"||_230===null){
return undefined;
}
return _230.getPropertyValue(_22c);
},getElementsByTagAndClassName:function(_231,_232,_233){
var self=MochiKit.DOM;
if(typeof (_231)=="undefined"||_231===null){
_231="*";
}
if(typeof (_233)=="undefined"||_233===null){
_233=self._document;
}
_233=self.getElement(_233);
var _235=(_233.getElementsByTagName(_231)||self._document.all);
if(typeof (_232)=="undefined"||_232===null){
return MochiKit.Base.extend(null,_235);
}
var _236=[];
for(var i=0;i<_235.length;i++){
var _238=_235[i];
var _239=_238.className.split(" ");
for(var j=0;j<_239.length;j++){
if(_239[j]==_232){
_236.push(_238);
break;
}
}
}
return _236;
},_newCallStack:function(path,once){
var rval=function(){
var _23e=arguments.callee.callStack;
for(var i=0;i<_23e.length;i++){
if(_23e[i].apply(this,arguments)===false){
break;
}
}
if(once){
try{
this[path]=null;
}
catch(e){
}
}
};
rval.callStack=[];
return rval;
},addToCallStack:function(_240,path,func,once){
var self=MochiKit.DOM;
var _245=_240[path];
var _246=_245;
if(!(typeof (_245)=="function"&&typeof (_245.callStack)=="object"&&_245.callStack!==null)){
_246=self._newCallStack(path,once);
if(typeof (_245)=="function"){
_246.callStack.push(_245);
}
_240[path]=_246;
}
_246.callStack.push(func);
},addLoadEvent:function(func){
var self=MochiKit.DOM;
self.addToCallStack(self._window,"onload",func,true);
},focusOnLoad:function(_249){
var self=MochiKit.DOM;
self.addLoadEvent(function(){
_249=self.getElement(_249);
if(_249){
_249.focus();
}
});
},setElementClass:function(_24b,_24c){
var self=MochiKit.DOM;
var obj=self.getElement(_24b);
if(self.attributeArray.compliant){
obj.setAttribute("class",_24c);
}else{
obj.setAttribute("className",_24c);
}
},toggleElementClass:function(_24f){
var self=MochiKit.DOM;
for(var i=1;i<arguments.length;i++){
var obj=self.getElement(arguments[i]);
if(!self.addElementClass(obj,_24f)){
self.removeElementClass(obj,_24f);
}
}
},addElementClass:function(_253,_254){
var self=MochiKit.DOM;
var obj=self.getElement(_253);
var cls=obj.className;
if(cls.length===0){
self.setElementClass(obj,_254);
return true;
}
if(cls==_254){
return false;
}
var _258=obj.className.split(" ");
for(var i=0;i<_258.length;i++){
if(_258[i]==_254){
return false;
}
}
self.setElementClass(obj,cls+" "+_254);
return true;
},removeElementClass:function(_25a,_25b){
var self=MochiKit.DOM;
var obj=self.getElement(_25a);
var cls=obj.className;
if(cls.length===0){
return false;
}
if(cls==_25b){
self.setElementClass(obj,"");
return true;
}
var _25f=obj.className.split(" ");
for(var i=0;i<_25f.length;i++){
if(_25f[i]==_25b){
_25f.splice(i,1);
self.setElementClass(obj,_25f.join(" "));
return true;
}
}
return false;
},swapElementClass:function(_261,_262,_263){
var obj=MochiKit.DOM.getElement(_261);
var res=MochiKit.DOM.removeElementClass(obj,_262);
if(res){
MochiKit.DOM.addElementClass(obj,_263);
}
return res;
},hasElementClass:function(_266,_267){
var obj=MochiKit.DOM.getElement(_266);
var _269=obj.className.split(" ");
for(var i=1;i<arguments.length;i++){
var good=false;
for(var j=0;j<_269.length;j++){
if(_269[j]==arguments[i]){
good=true;
break;
}
}
if(!good){
return false;
}
}
return true;
},escapeHTML:function(s){
return s.replace(/&/g,"&amp;").replace(/"/g,"&quot;").replace(/</g,"&lt;").replace(/>/g,"&gt;");
},toHTML:function(dom){
return MochiKit.DOM.emitHTML(dom).join("");
},emitHTML:function(dom,lst){
if(typeof (lst)=="undefined"||lst===null){
lst=[];
}
var _271=[dom];
var self=MochiKit.DOM;
var _273=self.escapeHTML;
var _274=self.attributeArray;
while(_271.length){
dom=_271.pop();
if(typeof (dom)=="string"){
lst.push(dom);
}else{
if(dom.nodeType==1){
lst.push("<"+dom.nodeName.toLowerCase());
var _275=[];
var _276=_274(dom);
for(var i=0;i<_276.length;i++){
var a=_276[i];
_275.push([" ",a.name,"=\"",_273(a.value),"\""]);
}
_275.sort();
for(i=0;i<_275.length;i++){
var _279=_275[i];
for(var j=0;j<_279.length;j++){
lst.push(_279[j]);
}
}
if(dom.hasChildNodes()){
lst.push(">");
_271.push("</"+dom.nodeName.toLowerCase()+">");
var _27b=dom.childNodes;
for(i=_27b.length-1;i>=0;i--){
_271.push(_27b[i]);
}
}else{
lst.push("/>");
}
}else{
if(dom.nodeType==3){
lst.push(_273(dom.nodeValue));
}
}
}
}
return lst;
},setDisplayForElement:function(_27c,_27d){
var m=MochiKit.Base;
var _27f=m.extend(null,arguments,1);
MochiKit.Iter.forEach(m.filter(null,m.map(MochiKit.DOM.getElement,_27f)),function(_280){
_280.style.display=_27c;
});
},scrapeText:function(node,_282){
var rval=[];
(function(node){
var cn=node.childNodes;
if(cn){
for(var i=0;i<cn.length;i++){
arguments.callee.call(this,cn[i]);
}
}
var _287=node.nodeValue;
if(typeof (_287)=="string"){
rval.push(_287);
}
})(MochiKit.DOM.getElement(node));
if(_282){
return rval;
}else{
return rval.join("");
}
},__new__:function(win){
var m=MochiKit.Base;
this._document=document;
this._window=win;
this.domConverters=new m.AdapterRegistry();
var _28a=this._document.createElement("span");
var _28b;
if(_28a&&_28a.attributes&&_28a.attributes.length>0){
var _28c=m.filter;
_28b=function(node){
return _28c(_28b.ignoreAttrFilter,node.attributes);
};
_28b.ignoreAttr={};
MochiKit.Iter.forEach(_28a.attributes,function(a){
_28b.ignoreAttr[a.name]=a.value;
});
_28b.ignoreAttrFilter=function(a){
return (_28b.ignoreAttr[a.name]!=a.value);
};
_28b.compliant=false;
_28b.renames={"class":"className","checked":"defaultChecked","usemap":"useMap","for":"htmlFor"};
}else{
_28b=function(node){
return node.attributes;
};
_28b.compliant=true;
_28b.renames={};
}
this.attributeArray=_28b;
var _291=this.createDOMFunc;
this.UL=_291("ul");
this.OL=_291("ol");
this.LI=_291("li");
this.TD=_291("td");
this.TR=_291("tr");
this.TBODY=_291("tbody");
this.THEAD=_291("thead");
this.TFOOT=_291("tfoot");
this.TABLE=_291("table");
this.TH=_291("th");
this.INPUT=_291("input");
this.SPAN=_291("span");
this.A=_291("a");
this.DIV=_291("div");
this.IMG=_291("img");
this.BUTTON=_291("button");
this.TT=_291("tt");
this.PRE=_291("pre");
this.H1=_291("h1");
this.H2=_291("h2");
this.H3=_291("h3");
this.BR=_291("br");
this.HR=_291("hr");
this.LABEL=_291("label");
this.TEXTAREA=_291("textarea");
this.FORM=_291("form");
this.P=_291("p");
this.SELECT=_291("select");
this.OPTION=_291("option");
this.OPTGROUP=_291("optgroup");
this.LEGEND=_291("legend");
this.FIELDSET=_291("fieldset");
this.STRONG=_291("strong");
this.CANVAS=_291("canvas");
this.hideElement=m.partial(this.setDisplayForElement,"none");
this.showElement=m.partial(this.setDisplayForElement,"block");
this.removeElement=this.swapDOM;
this.$=this.getElement;
this.EXPORT_TAGS={":common":this.EXPORT,":all":m.concat(this.EXPORT,this.EXPORT_OK)};
m.nameFunctions(this);
}});
MochiKit.DOM.__new__(((typeof (window)=="undefined")?this:window));
if(!MochiKit.__compat__){
withWindow=MochiKit.DOM.withWindow;
withDocument=MochiKit.DOM.withDocument;
}
MochiKit.Base._exportSymbols(this,MochiKit.DOM);
if(typeof (dojo)!="undefined"){
dojo.provide("MochiKit.Async");
dojo.require("MochiKit.Base");
}
if(typeof (JSAN)!="undefined"){
JSAN.use("MochiKit.Base",[]);
}
try{
if(typeof (MochiKit.Base)=="undefined"){
throw "";
}
}
catch(e){
throw "MochiKit.Async depends on MochiKit.Base!";
}
if(typeof (MochiKit.Async)=="undefined"){
MochiKit.Async={};
}
MochiKit.Async.NAME="MochiKit.Async";
MochiKit.Async.VERSION="1.3.1";
MochiKit.Async.__repr__=function(){
return "["+this.NAME+" "+this.VERSION+"]";
};
MochiKit.Async.toString=function(){
return this.__repr__();
};
MochiKit.Async.Deferred=function(_292){
this.chain=[];
this.id=this._nextId();
this.fired=-1;
this.paused=0;
this.results=[null,null];
this.canceller=_292;
this.silentlyCancelled=false;
this.chained=false;
};
MochiKit.Async.Deferred.prototype={repr:function(){
var _293;
if(this.fired==-1){
_293="unfired";
}else{
if(this.fired===0){
_293="success";
}else{
_293="error";
}
}
return "Deferred("+this.id+", "+_293+")";
},toString:MochiKit.Base.forwardCall("repr"),_nextId:MochiKit.Base.counter(),cancel:function(){
var self=MochiKit.Async;
if(this.fired==-1){
if(this.canceller){
this.canceller(this);
}else{
this.silentlyCancelled=true;
}
if(this.fired==-1){
this.errback(new self.CancelledError(this));
}
}else{
if((this.fired===0)&&(this.results[0] instanceof self.Deferred)){
this.results[0].cancel();
}
}
},_pause:function(){
this.paused++;
},_unpause:function(){
this.paused--;
if((this.paused===0)&&(this.fired>=0)){
this._fire();
}
},_continue:function(res){
this._resback(res);
this._unpause();
},_resback:function(res){
this.fired=((res instanceof Error)?1:0);
this.results[this.fired]=res;
this._fire();
},_check:function(){
if(this.fired!=-1){
if(!this.silentlyCancelled){
throw new MochiKit.Async.AlreadyCalledError(this);
}
this.silentlyCancelled=false;
return;
}
},callback:function(res){
this._check();
if(res instanceof MochiKit.Async.Deferred){
throw new Error("Deferred instances can only be chained if they are the result of a callback");
}
this._resback(res);
},errback:function(res){
this._check();
var self=MochiKit.Async;
if(res instanceof self.Deferred){
throw new Error("Deferred instances can only be chained if they are the result of a callback");
}
if(!(res instanceof Error)){
res=new self.GenericError(res);
}
this._resback(res);
},addBoth:function(fn){
if(arguments.length>1){
fn=MochiKit.Base.partial.apply(null,arguments);
}
return this.addCallbacks(fn,fn);
},addCallback:function(fn){
if(arguments.length>1){
fn=MochiKit.Base.partial.apply(null,arguments);
}
return this.addCallbacks(fn,null);
},addErrback:function(fn){
if(arguments.length>1){
fn=MochiKit.Base.partial.apply(null,arguments);
}
return this.addCallbacks(null,fn);
},addCallbacks:function(cb,eb){
if(this.chained){
throw new Error("Chained Deferreds can not be re-used");
}
this.chain.push([cb,eb]);
if(this.fired>=0){
this._fire();
}
return this;
},_fire:function(){
var _29f=this.chain;
var _2a0=this.fired;
var res=this.results[_2a0];
var self=this;
var cb=null;
while(_29f.length>0&&this.paused===0){
var pair=_29f.shift();
var f=pair[_2a0];
if(f===null){
continue;
}
try{
res=f(res);
_2a0=((res instanceof Error)?1:0);
if(res instanceof MochiKit.Async.Deferred){
cb=function(res){
self._continue(res);
};
this._pause();
}
}
catch(err){
_2a0=1;
if(!(err instanceof Error)){
err=new MochiKit.Async.GenericError(err);
}
res=err;
}
}
this.fired=_2a0;
this.results[_2a0]=res;
if(cb&&this.paused){
res.addBoth(cb);
res.chained=true;
}
}};
MochiKit.Base.update(MochiKit.Async,{evalJSONRequest:function(){
return eval("("+arguments[0].responseText+")");
},succeed:function(_2a7){
var d=new MochiKit.Async.Deferred();
d.callback.apply(d,arguments);
return d;
},fail:function(_2a9){
var d=new MochiKit.Async.Deferred();
d.errback.apply(d,arguments);
return d;
},getXMLHttpRequest:function(){
var self=arguments.callee;
if(!self.XMLHttpRequest){
var _2ac=[function(){
return new XMLHttpRequest();
},function(){
return new ActiveXObject("Msxml2.XMLHTTP");
},function(){
return new ActiveXObject("Microsoft.XMLHTTP");
},function(){
return new ActiveXObject("Msxml2.XMLHTTP.4.0");
},function(){
throw new MochiKit.Async.BrowserComplianceError("Browser does not support XMLHttpRequest");
}];
for(var i=0;i<_2ac.length;i++){
var func=_2ac[i];
try{
self.XMLHttpRequest=func;
return func();
}
catch(e){
}
}
}
return self.XMLHttpRequest();
},_nothing:function(){
},_xhr_onreadystatechange:function(d){
if(this.readyState==4){
try{
this.onreadystatechange=null;
}
catch(e){
try{
this.onreadystatechange=MochiKit.Async._nothing;
}
catch(e){
}
}
var _2b0=null;
try{
_2b0=this.status;
if(!_2b0&&MochiKit.Base.isNotEmpty(this.responseText)){
_2b0=304;
}
}
catch(e){
}
if(_2b0==200||_2b0==304){
d.callback(this);
}else{
var err=new MochiKit.Async.XMLHttpRequestError(this,"Request failed");
if(err.number){
d.errback(err);
}else{
d.errback(err);
}
}
}
},_xhr_canceller:function(req){
try{
req.onreadystatechange=null;
}
catch(e){
try{
req.onreadystatechange=MochiKit.Async._nothing;
}
catch(e){
}
}
req.abort();
},sendXMLHttpRequest:function(req,_2b4){
if(typeof (_2b4)=="undefined"||_2b4===null){
_2b4="";
}
var m=MochiKit.Base;
var self=MochiKit.Async;
var d=new self.Deferred(m.partial(self._xhr_canceller,req));
try{
req.onreadystatechange=m.bind(self._xhr_onreadystatechange,req,d);
req.send(_2b4);
}
catch(e){
try{
req.onreadystatechange=null;
}
catch(ignore){
}
d.errback(e);
}
return d;
},doSimpleXMLHttpRequest:function(url){
var self=MochiKit.Async;
var req=self.getXMLHttpRequest();
if(arguments.length>1){
var m=MochiKit.Base;
var qs=m.queryString.apply(null,m.extend(null,arguments,1));
if(qs){
url+="?"+qs;
}
}
req.open("GET",url,true);
return self.sendXMLHttpRequest(req);
},loadJSONDoc:function(url){
var self=MochiKit.Async;
var d=self.doSimpleXMLHttpRequest.apply(self,arguments);
d=d.addCallback(self.evalJSONRequest);
return d;
},wait:function(_2c0,_2c1){
var d=new MochiKit.Async.Deferred();
var m=MochiKit.Base;
if(typeof (_2c1)!="undefined"){
d.addCallback(function(){
return _2c1;
});
}
var _2c4=setTimeout(m.bind("callback",d),Math.floor(_2c0*1000));
d.canceller=function(){
try{
clearTimeout(_2c4);
}
catch(e){
}
};
return d;
},callLater:function(_2c5,func){
var m=MochiKit.Base;
var _2c8=m.partial.apply(m,m.extend(null,arguments,1));
return MochiKit.Async.wait(_2c5).addCallback(function(res){
return _2c8();
});
}});
MochiKit.Async.DeferredLock=function(){
this.waiting=[];
this.locked=false;
this.id=this._nextId();
};
MochiKit.Async.DeferredLock.prototype={__class__:MochiKit.Async.DeferredLock,acquire:function(){
d=new MochiKit.Async.Deferred();
if(this.locked){
this.waiting.push(d);
}else{
this.locked=true;
d.callback(this);
}
return d;
},release:function(){
if(!this.locked){
throw TypeError("Tried to release an unlocked DeferredLock");
}
this.locked=false;
if(this.waiting.length>0){
this.locked=true;
this.waiting.shift().callback(this);
}
},_nextId:MochiKit.Base.counter(),repr:function(){
var _2ca;
if(this.locked){
_2ca="locked, "+this.waiting.length+" waiting";
}else{
_2ca="unlocked";
}
return "DeferredLock("+this.id+", "+_2ca+")";
},toString:MochiKit.Base.forwardCall("repr")};
MochiKit.Async.DeferredList=function(list,_2cc,_2cd,_2ce,_2cf){
this.list=list;
this.resultList=new Array(this.list.length);
this.chain=[];
this.id=this._nextId();
this.fired=-1;
this.paused=0;
this.results=[null,null];
this.canceller=_2cf;
this.silentlyCancelled=false;
if(this.list.length===0&&!_2cc){
this.callback(this.resultList);
}
this.finishedCount=0;
this.fireOnOneCallback=_2cc;
this.fireOnOneErrback=_2cd;
this.consumeErrors=_2ce;
var _2d0=0;
MochiKit.Base.map(MochiKit.Base.bind(function(d){
d.addCallback(MochiKit.Base.bind(this._cbDeferred,this),_2d0,true);
d.addErrback(MochiKit.Base.bind(this._cbDeferred,this),_2d0,false);
_2d0+=1;
},this),this.list);
};
MochiKit.Base.update(MochiKit.Async.DeferredList.prototype,MochiKit.Async.Deferred.prototype);
MochiKit.Base.update(MochiKit.Async.DeferredList.prototype,{_cbDeferred:function(_2d2,_2d3,_2d4){
this.resultList[_2d2]=[_2d3,_2d4];
this.finishedCount+=1;
if(this.fired!==0){
if(_2d3&&this.fireOnOneCallback){
this.callback([_2d2,_2d4]);
}else{
if(!_2d3&&this.fireOnOneErrback){
this.errback(_2d4);
}else{
if(this.finishedCount==this.list.length){
this.callback(this.resultList);
}
}
}
}
if(!_2d3&&this.consumeErrors){
_2d4=null;
}
return _2d4;
}});
MochiKit.Async.gatherResults=function(_2d5){
var d=new MochiKit.Async.DeferredList(_2d5,false,true,false);
d.addCallback(function(_2d7){
var ret=[];
for(var i=0;i<_2d7.length;i++){
ret.push(_2d7[i][1]);
}
return ret;
});
return d;
};
MochiKit.Async.maybeDeferred=function(func){
var self=MochiKit.Async;
var _2dc;
try{
var r=func.apply(null,MochiKit.Base.extend([],arguments,1));
if(r instanceof self.Deferred){
_2dc=r;
}else{
if(r instanceof Error){
_2dc=self.fail(r);
}else{
_2dc=self.succeed(r);
}
}
}
catch(e){
_2dc=self.fail(e);
}
return _2dc;
};
MochiKit.Async.EXPORT=["AlreadyCalledError","CancelledError","BrowserComplianceError","GenericError","XMLHttpRequestError","Deferred","succeed","fail","getXMLHttpRequest","doSimpleXMLHttpRequest","loadJSONDoc","wait","callLater","sendXMLHttpRequest","DeferredLock","DeferredList","gatherResults","maybeDeferred"];
MochiKit.Async.EXPORT_OK=["evalJSONRequest"];
MochiKit.Async.__new__=function(){
var m=MochiKit.Base;
var ne=m.partial(m._newNamedError,this);
ne("AlreadyCalledError",function(_2e0){
this.deferred=_2e0;
});
ne("CancelledError",function(_2e1){
this.deferred=_2e1;
});
ne("BrowserComplianceError",function(msg){
this.message=msg;
});
ne("GenericError",function(msg){
this.message=msg;
});
ne("XMLHttpRequestError",function(req,msg){
this.req=req;
this.message=msg;
try{
this.number=req.status;
}
catch(e){
}
});
this.EXPORT_TAGS={":common":this.EXPORT,":all":m.concat(this.EXPORT,this.EXPORT_OK)};
m.nameFunctions(this);
};
MochiKit.Async.__new__();
MochiKit.Base._exportSymbols(this,MochiKit.Async);
if(typeof (dojo)!="undefined"){
dojo.provide("MochiKit.Signal");
dojo.require("MochiKit.Base");
dojo.require("MochiKit.DOM");
}
if(typeof (JSAN)!="undefined"){
JSAN.use("MochiKit.Base",[]);
JSAN.use("MochiKit.DOM",[]);
}
try{
if(typeof (MochiKit.Base)=="undefined"){
throw "";
}
}
catch(e){
throw "MochiKit.Signal depends on MochiKit.Base!";
}
try{
if(typeof (MochiKit.DOM)=="undefined"){
throw "";
}
}
catch(e){
throw "MochiKit.Signal depends on MochiKit.DOM!";
}
if(typeof (MochiKit.Signal)=="undefined"){
MochiKit.Signal={};
}
MochiKit.Signal.NAME="MochiKit.Signal";
MochiKit.Signal.VERSION="1.3.1";
MochiKit.Signal._observers=[];
MochiKit.Signal.Event=function(src,e){
this._event=e||window.event;
this._src=src;
};
MochiKit.Base.update(MochiKit.Signal.Event.prototype,{__repr__:function(){
var repr=MochiKit.Base.repr;
var str="{event(): "+repr(this.event())+", src(): "+repr(this.src())+", type(): "+repr(this.type())+", target(): "+repr(this.target())+", modifier(): "+"{alt: "+repr(this.modifier().alt)+", ctrl: "+repr(this.modifier().ctrl)+", meta: "+repr(this.modifier().meta)+", shift: "+repr(this.modifier().shift)+", any: "+repr(this.modifier().any)+"}";
if(this.type()&&this.type().indexOf("key")===0){
str+=", key(): {code: "+repr(this.key().code)+", string: "+repr(this.key().string)+"}";
}
if(this.type()&&(this.type().indexOf("mouse")===0||this.type().indexOf("click")!=-1||this.type()=="contextmenu")){
str+=", mouse(): {page: "+repr(this.mouse().page)+", client: "+repr(this.mouse().client);
if(this.type()!="mousemove"){
str+=", button: {left: "+repr(this.mouse().button.left)+", middle: "+repr(this.mouse().button.middle)+", right: "+repr(this.mouse().button.right)+"}}";
}else{
str+="}";
}
}
if(this.type()=="mouseover"||this.type()=="mouseout"){
str+=", relatedTarget(): "+repr(this.relatedTarget());
}
str+="}";
return str;
},toString:function(){
return this.__repr__();
},src:function(){
return this._src;
},event:function(){
return this._event;
},type:function(){
return this._event.type||undefined;
},target:function(){
return this._event.target||this._event.srcElement;
},relatedTarget:function(){
if(this.type()=="mouseover"){
return (this._event.relatedTarget||this._event.fromElement);
}else{
if(this.type()=="mouseout"){
return (this._event.relatedTarget||this._event.toElement);
}
}
return undefined;
},modifier:function(){
var m={};
m.alt=this._event.altKey;
m.ctrl=this._event.ctrlKey;
m.meta=this._event.metaKey||false;
m.shift=this._event.shiftKey;
m.any=m.alt||m.ctrl||m.shift||m.meta;
return m;
},key:function(){
var k={};
if(this.type()&&this.type().indexOf("key")===0){
if(this.type()=="keydown"||this.type()=="keyup"){
k.code=this._event.keyCode;
k.string=(MochiKit.Signal._specialKeys[k.code]||"KEY_UNKNOWN");
return k;
}else{
if(this.type()=="keypress"){
k.code=0;
k.string="";
if(typeof (this._event.charCode)!="undefined"&&this._event.charCode!==0&&!MochiKit.Signal._specialMacKeys[this._event.charCode]){
k.code=this._event.charCode;
k.string=String.fromCharCode(k.code);
}else{
if(this._event.keyCode&&typeof (this._event.charCode)=="undefined"){
k.code=this._event.keyCode;
k.string=String.fromCharCode(k.code);
}
}
return k;
}
}
}
return undefined;
},mouse:function(){
var m={};
var e=this._event;
if(this.type()&&(this.type().indexOf("mouse")===0||this.type().indexOf("click")!=-1||this.type()=="contextmenu")){
m.client=new MochiKit.DOM.Coordinates(0,0);
if(e.clientX||e.clientY){
m.client.x=(!e.clientX||e.clientX<0)?0:e.clientX;
m.client.y=(!e.clientY||e.clientY<0)?0:e.clientY;
}
m.page=new MochiKit.DOM.Coordinates(0,0);
if(e.pageX||e.pageY){
m.page.x=(!e.pageX||e.pageX<0)?0:e.pageX;
m.page.y=(!e.pageY||e.pageY<0)?0:e.pageY;
}else{
var de=MochiKit.DOM._document.documentElement;
var b=MochiKit.DOM._document.body;
m.page.x=e.clientX+(de.scrollLeft||b.scrollLeft)-(de.clientLeft||b.clientLeft);
m.page.y=e.clientY+(de.scrollTop||b.scrollTop)-(de.clientTop||b.clientTop);
}
if(this.type()!="mousemove"){
m.button={};
m.button.left=false;
m.button.right=false;
m.button.middle=false;
if(e.which){
m.button.left=(e.which==1);
m.button.middle=(e.which==2);
m.button.right=(e.which==3);
}else{
m.button.left=!!(e.button&1);
m.button.right=!!(e.button&2);
m.button.middle=!!(e.button&4);
}
}
return m;
}
return undefined;
},stop:function(){
this.stopPropagation();
this.preventDefault();
},stopPropagation:function(){
if(this._event.stopPropagation){
this._event.stopPropagation();
}else{
this._event.cancelBubble=true;
}
},preventDefault:function(){
if(this._event.preventDefault){
this._event.preventDefault();
}else{
this._event.returnValue=false;
}
}});
MochiKit.Signal._specialMacKeys={3:"KEY_ENTER",63289:"KEY_NUM_PAD_CLEAR",63276:"KEY_PAGE_UP",63277:"KEY_PAGE_DOWN",63275:"KEY_END",63273:"KEY_HOME",63234:"KEY_ARROW_LEFT",63232:"KEY_ARROW_UP",63235:"KEY_ARROW_RIGHT",63233:"KEY_ARROW_DOWN",63302:"KEY_INSERT",63272:"KEY_DELETE"};
for(i=63236;i<=63242;i++){
MochiKit.Signal._specialMacKeys[i]="KEY_F"+(i-63236+1);
}
MochiKit.Signal._specialKeys={8:"KEY_BACKSPACE",9:"KEY_TAB",12:"KEY_NUM_PAD_CLEAR",13:"KEY_ENTER",16:"KEY_SHIFT",17:"KEY_CTRL",18:"KEY_ALT",19:"KEY_PAUSE",20:"KEY_CAPS_LOCK",27:"KEY_ESCAPE",32:"KEY_SPACEBAR",33:"KEY_PAGE_UP",34:"KEY_PAGE_DOWN",35:"KEY_END",36:"KEY_HOME",37:"KEY_ARROW_LEFT",38:"KEY_ARROW_UP",39:"KEY_ARROW_RIGHT",40:"KEY_ARROW_DOWN",44:"KEY_PRINT_SCREEN",45:"KEY_INSERT",46:"KEY_DELETE",59:"KEY_SEMICOLON",91:"KEY_WINDOWS_LEFT",92:"KEY_WINDOWS_RIGHT",93:"KEY_SELECT",106:"KEY_NUM_PAD_ASTERISK",107:"KEY_NUM_PAD_PLUS_SIGN",109:"KEY_NUM_PAD_HYPHEN-MINUS",110:"KEY_NUM_PAD_FULL_STOP",111:"KEY_NUM_PAD_SOLIDUS",144:"KEY_NUM_LOCK",145:"KEY_SCROLL_LOCK",186:"KEY_SEMICOLON",187:"KEY_EQUALS_SIGN",188:"KEY_COMMA",189:"KEY_HYPHEN-MINUS",190:"KEY_FULL_STOP",191:"KEY_SOLIDUS",192:"KEY_GRAVE_ACCENT",219:"KEY_LEFT_SQUARE_BRACKET",220:"KEY_REVERSE_SOLIDUS",221:"KEY_RIGHT_SQUARE_BRACKET",222:"KEY_APOSTROPHE"};
for(var i=48;i<=57;i++){
MochiKit.Signal._specialKeys[i]="KEY_"+(i-48);
}
for(i=65;i<=90;i++){
MochiKit.Signal._specialKeys[i]="KEY_"+String.fromCharCode(i);
}
for(i=96;i<=105;i++){
MochiKit.Signal._specialKeys[i]="KEY_NUM_PAD_"+(i-96);
}
for(i=112;i<=123;i++){
MochiKit.Signal._specialKeys[i]="KEY_F"+(i-112+1);
}
MochiKit.Base.update(MochiKit.Signal,{__repr__:function(){
return "["+this.NAME+" "+this.VERSION+"]";
},toString:function(){
return this.__repr__();
},_unloadCache:function(){
var self=MochiKit.Signal;
var _2f1=self._observers;
for(var i=0;i<_2f1.length;i++){
self._disconnect(_2f1[i]);
}
delete self._observers;
try{
window.onload=undefined;
}
catch(e){
}
try{
window.onunload=undefined;
}
catch(e){
}
},_listener:function(src,func,obj,_2f6){
var E=MochiKit.Signal.Event;
if(!_2f6){
return MochiKit.Base.bind(func,obj);
}
obj=obj||src;
if(typeof (func)=="string"){
return function(_2f8){
obj[func].apply(obj,[new E(src,_2f8)]);
};
}else{
return function(_2f9){
func.apply(obj,[new E(src,_2f9)]);
};
}
},connect:function(src,sig,_2fc,_2fd){
src=MochiKit.DOM.getElement(src);
var self=MochiKit.Signal;
if(typeof (sig)!="string"){
throw new Error("'sig' must be a string");
}
var obj=null;
var func=null;
if(typeof (_2fd)!="undefined"){
obj=_2fc;
func=_2fd;
if(typeof (_2fd)=="string"){
if(typeof (_2fc[_2fd])!="function"){
throw new Error("'funcOrStr' must be a function on 'objOrFunc'");
}
}else{
if(typeof (_2fd)!="function"){
throw new Error("'funcOrStr' must be a function or string");
}
}
}else{
if(typeof (_2fc)!="function"){
throw new Error("'objOrFunc' must be a function if 'funcOrStr' is not given");
}else{
func=_2fc;
}
}
if(typeof (obj)=="undefined"||obj===null){
obj=src;
}
var _301=!!(src.addEventListener||src.attachEvent);
var _302=self._listener(src,func,obj,_301);
if(src.addEventListener){
src.addEventListener(sig.substr(2),_302,false);
}else{
if(src.attachEvent){
src.attachEvent(sig,_302);
}
}
var _303=[src,sig,_302,_301,_2fc,_2fd];
self._observers.push(_303);
return _303;
},_disconnect:function(_304){
if(!_304[3]){
return;
}
var src=_304[0];
var sig=_304[1];
var _307=_304[2];
if(src.removeEventListener){
src.removeEventListener(sig.substr(2),_307,false);
}else{
if(src.detachEvent){
src.detachEvent(sig,_307);
}else{
throw new Error("'src' must be a DOM element");
}
}
},disconnect:function(_308){
var self=MochiKit.Signal;
var _30a=self._observers;
var m=MochiKit.Base;
if(arguments.length>1){
var src=MochiKit.DOM.getElement(arguments[0]);
var sig=arguments[1];
var obj=arguments[2];
var func=arguments[3];
for(var i=_30a.length-1;i>=0;i--){
var o=_30a[i];
if(o[0]===src&&o[1]===sig&&o[4]===obj&&o[5]===func){
self._disconnect(o);
_30a.splice(i,1);
return true;
}
}
}else{
var idx=m.findIdentical(_30a,_308);
if(idx>=0){
self._disconnect(_308);
_30a.splice(idx,1);
return true;
}
}
return false;
},disconnectAll:function(src,sig){
src=MochiKit.DOM.getElement(src);
var m=MochiKit.Base;
var _316=m.flattenArguments(m.extend(null,arguments,1));
var self=MochiKit.Signal;
var _318=self._disconnect;
var _319=self._observers;
if(_316.length===0){
for(var i=_319.length-1;i>=0;i--){
var _31b=_319[i];
if(_31b[0]===src){
_318(_31b);
_319.splice(i,1);
}
}
}else{
var sigs={};
for(var i=0;i<_316.length;i++){
sigs[_316[i]]=true;
}
for(var i=_319.length-1;i>=0;i--){
var _31b=_319[i];
if(_31b[0]===src&&_31b[1] in sigs){
_318(_31b);
_319.splice(i,1);
}
}
}
},signal:function(src,sig){
var _31f=MochiKit.Signal._observers;
src=MochiKit.DOM.getElement(src);
var args=MochiKit.Base.extend(null,arguments,2);
var _321=[];
for(var i=0;i<_31f.length;i++){
var _323=_31f[i];
if(_323[0]===src&&_323[1]===sig){
try{
_323[2].apply(src,args);
}
catch(e){
_321.push(e);
}
}
}
if(_321.length==1){
throw _321[0];
}else{
if(_321.length>1){
var e=new Error("Multiple errors thrown in handling 'sig', see errors property");
e.errors=_321;
throw e;
}
}
}});
MochiKit.Signal.EXPORT_OK=[];
MochiKit.Signal.EXPORT=["connect","disconnect","signal","disconnectAll"];
MochiKit.Signal.__new__=function(win){
var m=MochiKit.Base;
this._document=document;
this._window=win;
try{
this.connect(window,"onunload",this._unloadCache);
}
catch(e){
}
this.EXPORT_TAGS={":common":this.EXPORT,":all":m.concat(this.EXPORT,this.EXPORT_OK)};
m.nameFunctions(this);
};
MochiKit.Signal.__new__(this);
if(!MochiKit.__compat__){
connect=MochiKit.Signal.connect;
disconnect=MochiKit.Signal.disconnect;
disconnectAll=MochiKit.Signal.disconnectAll;
signal=MochiKit.Signal.signal;
}
MochiKit.Base._exportSymbols(this,MochiKit.Signal);
if(typeof (dojo)!="undefined"){
dojo.provide("MochiKit.Logging");
dojo.require("MochiKit.Base");
}
if(typeof (JSAN)!="undefined"){
JSAN.use("MochiKit.Base",[]);
}
try{
if(typeof (MochiKit.Base)=="undefined"){
throw "";
}
}
catch(e){
throw "MochiKit.Logging depends on MochiKit.Base!";
}
if(typeof (MochiKit.Logging)=="undefined"){
MochiKit.Logging={};
}
MochiKit.Logging.NAME="MochiKit.Logging";
MochiKit.Logging.VERSION="1.3.1";
MochiKit.Logging.__repr__=function(){
return "["+this.NAME+" "+this.VERSION+"]";
};
MochiKit.Logging.toString=function(){
return this.__repr__();
};
MochiKit.Logging.EXPORT=["LogLevel","LogMessage","Logger","alertListener","logger","log","logError","logDebug","logFatal","logWarning"];
MochiKit.Logging.EXPORT_OK=["logLevelAtLeast","isLogMessage","compareLogMessage"];
MochiKit.Logging.LogMessage=function(num,_328,info){
this.num=num;
this.level=_328;
this.info=info;
this.timestamp=new Date();
};
MochiKit.Logging.LogMessage.prototype={repr:function(){
var m=MochiKit.Base;
return "LogMessage("+m.map(m.repr,[this.num,this.level,this.info]).join(", ")+")";
},toString:MochiKit.Base.forwardCall("repr")};
MochiKit.Base.update(MochiKit.Logging,{logLevelAtLeast:function(_32b){
var self=MochiKit.Logging;
if(typeof (_32b)=="string"){
_32b=self.LogLevel[_32b];
}
return function(msg){
var _32e=msg.level;
if(typeof (_32e)=="string"){
_32e=self.LogLevel[_32e];
}
return _32e>=_32b;
};
},isLogMessage:function(){
var _32f=MochiKit.Logging.LogMessage;
for(var i=0;i<arguments.length;i++){
if(!(arguments[i] instanceof _32f)){
return false;
}
}
return true;
},compareLogMessage:function(a,b){
return MochiKit.Base.compare([a.level,a.info],[b.level,b.info]);
},alertListener:function(msg){
alert("num: "+msg.num+"\nlevel: "+msg.level+"\ninfo: "+msg.info.join(" "));
}});
MochiKit.Logging.Logger=function(_334){
this.counter=0;
if(typeof (_334)=="undefined"||_334===null){
_334=-1;
}
this.maxSize=_334;
this._messages=[];
this.listeners={};
this.useNativeConsole=false;
};
MochiKit.Logging.Logger.prototype={clear:function(){
this._messages.splice(0,this._messages.length);
},logToConsole:function(msg){
if(typeof (window)!="undefined"&&window.console&&window.console.log){
window.console.log(msg);
}else{
if(typeof (opera)!="undefined"&&opera.postError){
opera.postError(msg);
}else{
if(typeof (printfire)=="function"){
printfire(msg);
}
}
}
},dispatchListeners:function(msg){
for(var k in this.listeners){
var pair=this.listeners[k];
if(pair.ident!=k||(pair[0]&&!pair[0](msg))){
continue;
}
pair[1](msg);
}
},addListener:function(_339,_33a,_33b){
if(typeof (_33a)=="string"){
_33a=MochiKit.Logging.logLevelAtLeast(_33a);
}
var _33c=[_33a,_33b];
_33c.ident=_339;
this.listeners[_339]=_33c;
},removeListener:function(_33d){
delete this.listeners[_33d];
},baseLog:function(_33e,_33f){
var msg=new MochiKit.Logging.LogMessage(this.counter,_33e,MochiKit.Base.extend(null,arguments,1));
this._messages.push(msg);
this.dispatchListeners(msg);
if(this.useNativeConsole){
this.logToConsole(msg.level+": "+msg.info.join(" "));
}
this.counter+=1;
while(this.maxSize>=0&&this._messages.length>this.maxSize){
this._messages.shift();
}
},getMessages:function(_341){
var _342=0;
if(!(typeof (_341)=="undefined"||_341===null)){
_342=Math.max(0,this._messages.length-_341);
}
return this._messages.slice(_342);
},getMessageText:function(_343){
if(typeof (_343)=="undefined"||_343===null){
_343=30;
}
var _344=this.getMessages(_343);
if(_344.length){
var lst=map(function(m){
return "\n  ["+m.num+"] "+m.level+": "+m.info.join(" ");
},_344);
lst.unshift("LAST "+_344.length+" MESSAGES:");
return lst.join("");
}
return "";
},debuggingBookmarklet:function(_347){
if(typeof (MochiKit.LoggingPane)=="undefined"){
alert(this.getMessageText());
}else{
MochiKit.LoggingPane.createLoggingPane(_347||false);
}
}};
MochiKit.Logging.__new__=function(){
this.LogLevel={ERROR:40,FATAL:50,WARNING:30,INFO:20,DEBUG:10};
var m=MochiKit.Base;
m.registerComparator("LogMessage",this.isLogMessage,this.compareLogMessage);
var _349=m.partial;
var _34a=this.Logger;
var _34b=_34a.prototype.baseLog;
m.update(this.Logger.prototype,{debug:_349(_34b,"DEBUG"),log:_349(_34b,"INFO"),error:_349(_34b,"ERROR"),fatal:_349(_34b,"FATAL"),warning:_349(_34b,"WARNING")});
var self=this;
var _34d=function(name){
return function(){
self.logger[name].apply(self.logger,arguments);
};
};
this.log=_34d("log");
this.logError=_34d("error");
this.logDebug=_34d("debug");
this.logFatal=_34d("fatal");
this.logWarning=_34d("warning");
this.logger=new _34a();
this.logger.useNativeConsole=true;
this.EXPORT_TAGS={":common":this.EXPORT,":all":m.concat(this.EXPORT,this.EXPORT_OK)};
m.nameFunctions(this);
};
if(typeof (printfire)=="undefined"&&typeof (document)!="undefined"&&document.createEvent&&typeof (dispatchEvent)!="undefined"){
printfire=function(){
printfire.args=arguments;
var ev=document.createEvent("Events");
ev.initEvent("printfire",false,true);
dispatchEvent(ev);
};
}
MochiKit.Logging.__new__();
MochiKit.Base._exportSymbols(this,MochiKit.Logging);
function KeyboardManager(id){
this.panelID=id;
this.keyboardArea=MochiKit.DOM.getElement(id+"_keyboardArea");
this.exKey="none";
this.hasExtraMap=false;
this.mapLoaded=false;
this.backends={};
}
KeyboardManager.prototype={doIt:function(lang){
if(lang!=this.saveData[2]){
return;
}
if(this.backends.hasOwnProperty(lang)){
return;
}
this.backends[lang]=new Backend(lang);
this.exKey=new backendExtraKeys();
this.doRest(this.saveData[0],this.saveData[1],this.saveData[2],this.saveData[3]);
},toggleLoading:function(on){
if(on){
MochiKit.DOM.getElement(this.panelID+"_vkbLoading").style.display="block";
}else{
MochiKit.DOM.getElement(this.panelID+"_vkbLoading").style.display="none";
}
},doRest:function(node,_354,lang,_356){
this.backend=this.backends[lang];
this.info=[node,_354,lang];
this.toggleLoading(false);
this.mainTable=new MainTable(this,this.backend,this.panelID);
},show:function(lang){
var node="";
var _359="";
var _35a="";
this.mapLoaded=false;
var that=this;
function loadScript(){
var loc=Quill.Config.server.quillPath+"/";
that.saveData=[node,_359,lang,_35a];
var _35d=document.createElement("script");
var head=document.getElementsByTagName("head")[0];
_35d.setAttribute("type","text/javascript");
_35d.setAttribute("src",loc+lang+"_map.cms");
if(!that.hasExtraMap){
var _35f=document.createElement("script");
_35f.setAttribute("type","text/javascript");
_35f.setAttribute("src",loc+"extra_keymap.cms");
}
head.appendChild(_35d);
if(!that.hasExtraMap){
head.appendChild(_35f);
}
}
if(!this.backends.hasOwnProperty(lang)){
this.toggleLoading(true);
Quill.onLangMapLoad(this.panelID,lang);
loadScript();
}else{
this.doRest(node,_359,lang,_35a);
}
}};
KeyboardManager.prototype.getCurrentWord=function(){
return "";
};
KeyboardManager.prototype.setOptions=function(_360){
this.replaceWord(_360[0]);
};
KeyboardManager.prototype.replaceWord=function(word){
};
KeyboardManager.prototype.refreshDisplay=function(){
};
KeyboardManager.prototype.onKeyDown=function(evt){
var s=evt.key().string;
if(s=="KEY_TAB"){
this.mainTable.tab(evt.modifier().shift);
evt.stop();
}else{
if(s.match(/^KEY_[A-Z]$/)||s.match(/^KEY_[0-9]/)){
if(evt.modifier().ctrl||evt.modifier().alt){
return;
}
s=s.toLowerCase();
this.mainTable.hintMain(s.charAt(4),evt.modifier().shift);
evt.stop();
}else{
if(s.match(/^KEY_ARROW_/)){
if(!evt.modifier().shift){
s=s.toLowerCase();
s=s.slice(10);
this.mainTable.moveCursorMain(s);
evt.stop();
}
}else{
if(evt.modifier().shift){
if(s=="KEY_ENTER"){
}
evt.stop();
}else{
if(s=="KEY_ENTER"){
this.mainTable.select();
evt.stop();
}else{
if(s=="KEY_ESCAPE"){
this.mainTable.kill();
evt.stop();
}else{
if(s=="KEY_SPACEBAR"){
this.refreshDisplay();
evt.stop();
}else{
if(s=="KEY_BACKSPACE"){
this.refreshDisplay();
evt.stop();
}else{
}
}
}
}
}
}
}
}
};
function MainTable(_364,_365,_366){
this.panelID=_366;
this.key=null;
this.backend=_365;
this.mainmgr=_364;
this.table=null;
this.keyArea=MochiKit.DOM.getElement(this.panelID+"_keyboardArea");
this.secondaryTable=null;
this.coloredCells=[];
this.defaultColor="#E9EEF7";
this.depth=0;
this.sigList=[];
this.populate();
this.setCursor([0,0]);
this.coloredCells=[];
}
MainTable.prototype.setCursor=function(pos){
this.cursorPos=pos;
this.colorCellBasic(pos,Quill.Config.client.keyboard.cursorColor);
};
MainTable.prototype.removeSecondaryTable=function(){
if(this.secondaryTable){
this.secondaryTable.cleanup();
this.secondaryTable=null;
}
};
MainTable.prototype.kill=function(){
if(this.secondaryTable){
this.removeSecondaryTable();
}else{
this.highlight(null);
this.coloredCells=[];
this.hKey=null;
this.colorCellBasic(this.cursorPos,Quill.Config.client.keyboard.cursorColor);
}
};
MainTable.prototype.hintMain=function(c,_369){
if(this.secondaryTable){
this.secondaryTable.hint(c,_369);
}else{
this.hint(c,_369);
}
};
MainTable.prototype.select=function(){
if(this.secondaryTable){
this.secondaryTable.select();
return;
}
var src=this.getSelectedKey();
this.keyPressed({"src":function(){
return src;
},"stop":function(){
}});
};
MainTable.prototype.moveCursorMain=function(_36b){
if(this.secondaryTable){
this.secondaryTable.moveCursor(_36b);
}else{
this.moveCursor(_36b);
}
};
MainTable.prototype.tab=function(_36c){
if(this.secondaryTable){
this.secondaryTable.tabMove(_36c);
}else{
this.tabMove(_36c);
}
};
MainTable.prototype.onTableClick=function(){
this.removeSecondaryTable();
};
MainTable.prototype.closeTable=function(){
};
MainTable.prototype.populate=function(){
var l=this.backend.getKeyMap();
var ex=this.mainmgr.exKey.extraKeyMap;
var a=l[l.length-1];
var that=this;
this.createHintMap(l);
function getTD(val){
var s=document.createElement("SUB");
s.id="QuillSub";
var t=document.createTextNode(that.backend.getHint(val[0],that.depth));
MochiKit.DOM.appendChildNodes(s,t);
var td=MochiKit.DOM.TD({"class":"QuillKeytd"},val[0],s);
var sig=MochiKit.Signal.connect(td,"onclick",that,that.keyPressed);
that.sigList.push(sig);
MochiKit.DOM.setNodeAttribute(td,"content",val[0]);
return td;
}
function rowDisplay(row){
return MochiKit.DOM.TR(null,MochiKit.Base.map(getTD,row));
}
function extraTD(val){
var td=MochiKit.DOM.TD({"class":"QuillKeytd","align":"center","style":"font-weight: bold"},val[0]);
var sig=MochiKit.Signal.connect(td,"onclick",that,that.extraKeyPressed);
that.sigList.push(sig);
MochiKit.DOM.setNodeAttribute(td,"content",val[1]);
MochiKit.DOM.setNodeAttribute(td,"colSpan",val[2]);
return td;
}
function addExtraKeys(row){
return MochiKit.DOM.TR(null,MochiKit.Base.map(extraTD,row));
}
function createTable(l){
var data=ex;
var rows=MochiKit.Base.map(rowDisplay,l);
var r=MochiKit.Base.map(addExtraKeys,data);
rows.push(r);
return MochiKit.DOM.TABLE({"cellpadding":"2","cellspacing":"2"},MochiKit.DOM.TBODY(null,rows));
}
var t=createTable(l);
MochiKit.DOM.appendChildNodes(this.keyArea,t);
this.table=t;
MochiKit.Signal.connect(t,"onclick",this,this.onTableClick);
};
MainTable.prototype.extraKeyPressed=function(evt){
var c=MochiKit.DOM.getNodeAttribute(evt.src(),"content");
Quill.addChar(this.panelID,c);
evt.stop();
};
MainTable.prototype.keyPressed=function(evt){
var c=MochiKit.DOM.getNodeAttribute(evt.src(),"content");
var _384=this.mainmgr.getCurrentWord();
var _385;
var e;
if(c==this.key){
_385=this.backend.getWordOptions(_384,c);
this.mainmgr.setOptions(_385);
Quill.addChar(this.panelID,c);
this.removeSecondaryTable();
evt.stop();
this.key=null;
return;
}
this.removeSecondaryTable();
this.key=c;
e={pageX:MochiKit.DOM.elementPosition(evt.src()).x,pageY:MochiKit.DOM.elementPosition(evt.src()).y};
_385=this.backend.getWord(_384,c);
if(_385[0].length<1&&_385[1].length<1){
_385=this.backend.getWordOptions(_384,c);
this.mainmgr.setOptions(_385);
Quill.addChar(this.panelID,c);
}else{
this.secondaryTable=new SecondaryTable(this.mainmgr,this.backend,this,e,_385,this.panelID);
}
evt.stop();
};
MainTable.prototype.secondaryDone=function(){
this.secondaryTable=null;
this.key=null;
};
MainTable.prototype.cleanup=function(){
this.removeSecondaryTable();
this.cleanupSigs();
MochiKit.DOM.removeElement(this.table);
};
MainTable.prototype.cleanupSigs=function(){
var i=0;
for(i=0;i<this.sigList.length;i++){
MochiKit.Signal.disconnect(this.sigList[i]);
}
};
MainTable.prototype.moveCursor=function(_388){
var pos=this.calcCursor(_388);
for(var i=0;i<this.coloredCells.length;i++){
if(MochiKit.Base.compare(pos,this.coloredCells[i])===0){
break;
}
}
var that=this;
if(i===this.coloredCells.length){
MochiKit.Base.map(function(x){
that.colorCellBasic(x,that.defaultColor);
},this.coloredCells);
this.coloredCells=[];
this.hKey=null;
this.colorCellBasic(this.cursorPos,this.defaultColor);
}else{
this.colorCellBasic(this.cursorPos,Quill.Config.client.keyboard.hintColor);
}
this.setCursor(pos);
};
MainTable.prototype.getSelectedKey=function(){
var r=this.cursorPos[0];
var c=this.cursorPos[1];
return this.table.childNodes[0].childNodes[r].childNodes[c];
};
MainTable.prototype.calcCursor=function(_38f){
var row=this.cursorPos[0];
var _391=this.cursorPos[1];
var that=this;
function boxRule(r,c){
if(c<that.rowLengths[r]){
return c;
}
return that.rowLengths[r]-1;
}
switch(_38f){
case "up":
if(row===0){
row=this.rowLengths.length-1;
}else{
row-=1;
}
_391=boxRule(row,_391);
break;
case "down":
if(row===this.rowLengths.length-1){
row=0;
}else{
row+=1;
}
_391=boxRule(row,_391);
break;
case "right":
if(_391===this.rowLengths[row]-1){
_391=0;
}else{
_391+=1;
}
break;
case "left":
if(_391===0){
_391=this.rowLengths[row]-1;
}else{
_391-=1;
}
break;
}
return [row,_391];
};
MainTable.prototype.highlight=function(c){
for(i=0;i<this.coloredCells.length;i++){
this.colorCellBasic(this.coloredCells[i],this.defaultColor);
}
if(!c){
return;
}
var that=this;
var l=this.hintMap[c];
if(!l||!l.length){
this.colorCellBasic(this.cursorPos,Quill.Config.client.keyboard.cursorColor);
return;
}
var i;
for(i=0;i<l.length;i++){
this.colorCellBasic(l[i],Quill.Config.client.keyboard.hintColor);
}
this.setCursor(l[0]);
this.coloredCells=l;
};
MainTable.prototype.createHintMap=function(_399){
var i,j,c,m;
this.hintMap={};
this.rowLengths=[];
for(i=0;i<_399.length;i++){
this.rowLengths.push(_399[i].length);
for(j=0;j<_399[i].length;j++){
c=_399[i][j][0];
m=this.backend.getHint(c,this.depth);
if(this.hintMap[m]){
this.hintMap[m].push([i,j]);
}else{
this.hintMap[m]=[[i,j]];
}
}
}
};
MainTable.prototype.colorCellBasic=function(pos,_39f){
if(!this.table){
return;
}
var i,j;
i=pos[0];
j=pos[1];
var tr=this.table.childNodes[0].childNodes[i];
if(!tr){
return;
}
var td=tr.childNodes[j];
if(!td){
return;
}
var _3a4=td.style.background;
td.style.background=_39f;
return _3a4;
};
MainTable.prototype.tabMove=function(_3a5){
if(this.hKey){
if(_3a5){
if(this.cursorPosInHint==0){
this.cursorPosInHint=this.coloredCells.length-1;
}else{
this.cursorPosInHint-=1;
}
}else{
if(this.cursorPosInHint==this.coloredCells.length-1){
this.cursorPosInHint=0;
}else{
this.cursorPosInHint+=1;
}
}
this.colorCellBasic(this.cursorPos,Quill.Config.client.keyboard.hintColor);
var pos=this.coloredCells[this.cursorPosInHint];
this.setCursor(pos);
}
};
MainTable.prototype.hint=function(c,_3a8){
if(this.hKey===c){
if(_3a8){
if(this.cursorPosInHint==0){
this.cursorPosInHint=this.coloredCells.length-1;
}else{
this.cursorPosInHint-=1;
}
}else{
if(this.cursorPosInHint==this.coloredCells.length-1){
this.cursorPosInHint=0;
}else{
this.cursorPosInHint+=1;
}
}
this.colorCellBasic(this.cursorPos,Quill.Config.client.keyboard.hintColor);
var pos=this.coloredCells[this.cursorPosInHint];
this.setCursor(pos);
return;
}else{
this.colorCellBasic(this.cursorPos,this.defaultColor);
this.highlight(c);
this.hKey=c;
this.cursorPosInHint=0;
}
};
function SecondaryTable(_3aa,_3ab,_3ac,_3ad,_3ae,_3af){
this.panelID=_3af;
this.table=null;
this.sigList=null;
this.mainTable=_3ac;
this.mainmgr=_3aa;
this.backend=_3ab;
this.cursorPos=[0,0];
this.coloredCells=[];
this.defaultColor="#FFFFA0";
this.depth=1;
this.keyPos=MochiKit.DOM.getElement(this.panelID+"_keyboardArea");
this.keyDim=MochiKit.DOM.getElement(this.panelID+"_keyboardArea");
this.populate(_3ad,_3ae);
this.setCursor([0,0]);
}
SecondaryTable.prototype.keyPressed=function(evt){
var c=MochiKit.DOM.getNodeAttribute(evt.src(),"content");
var _3b2=this.mainmgr.getCurrentWord();
var _3b3;
_3b3=this.backend.getWordOptions(_3b2,c);
this.mainmgr.setOptions(_3b3);
this.cleanup();
Quill.addChar(this.panelID,c);
};
SecondaryTable.prototype.cleanup=function(evt){
this.cleanupSigs();
MochiKit.DOM.removeElement(this.table);
this.mainTable.secondaryDone();
};
SecondaryTable.prototype.select=function(){
var src=this.getSelectedKey();
this.keyPressed({"src":function(){
return src;
},"stop":function(){
}});
};
SecondaryTable.prototype.populate=function(e,_3b7){
var that=this;
var a=_3b7;
this.sigList=[];
function getTD(val){
var s=document.createElement("SUB");
s.id="QuillSub";
var t=document.createTextNode(that.backend.getHint(val[0],that.depth));
s.appendChild(t);
var td=MochiKit.DOM.TD({"class":"QuillAbstable","content":val[0]},val[0],s);
var sig=MochiKit.Signal.connect(td,"onclick",that,that.keyPressed);
that.sigList.push(sig);
return td;
}
var t,t2;
var tr1=MochiKit.DOM.TR(null,MochiKit.Base.map(getTD,a[0]));
if(a[1].length>0){
tr2=MochiKit.DOM.TR(null,MochiKit.Base.map(getTD,a[1]));
t=MochiKit.DOM.TABLE(null,MochiKit.DOM.TBODY(null,[tr1,tr2]));
this.createHintMap(a);
}else{
t=MochiKit.DOM.TABLE(null,MochiKit.DOM.TBODY(null,[tr1]));
this.createHintMap([a[0]]);
}
this.table=t;
MochiKit.DOM.setElementClass(t,"QuillAbstable");
MochiKit.DOM.setElementPosition(t,{x:e.pageX,y:e.pageY+15});
MochiKit.DOM.appendChildNodes(document.getElementsByTagName("body")[0],t);
};
SecondaryTable.prototype.cleanupSigs=MainTable.prototype.cleanupSigs;
SecondaryTable.prototype.moveCursor=MainTable.prototype.moveCursor;
SecondaryTable.prototype.calcCursor=MainTable.prototype.calcCursor;
SecondaryTable.prototype.createHintMap=MainTable.prototype.createHintMap;
SecondaryTable.prototype.getSelectedKey=MainTable.prototype.getSelectedKey;
SecondaryTable.prototype.highlight=MainTable.prototype.highlight;
SecondaryTable.prototype.hint=MainTable.prototype.hint;
SecondaryTable.prototype.tabMove=MainTable.prototype.tabMove;
SecondaryTable.prototype.colorCellBasic=MainTable.prototype.colorCellBasic;
SecondaryTable.prototype.setCursor=MainTable.prototype.setCursor;
function Backend(lang){
this.keyMap=eval(["(",lang,"_keymap.map",")"].join(""));
this.interfaceMap=eval(["(",lang,"_interfacemap",")"].join(""));
this.pattern=eval(lang+"_pattern");
this.typeMap={};
this.reverseTypeMap={};
this.mathras=[];
this.uHintMap={};
var _3c3=eval(["(",lang,"_zwnjmap",")"].join(""));
this.zwjSignificant=_3c3.zwjSignificant;
this.zwnjSignificant=_3c3.zwnjSignificant;
this.zwjCode=_3c3.zwjCode;
this.zwnjCode=_3c3.zwnjCode;
this.halanth=_3c3.halanth;
this.nukta=_3c3.nukta;
var that=this;
MochiKit.Base.map(function(x){
that.mathras.push(x);
},this.keyMap[0]);
var i,j,t;
for(i=0;i<this.keyMap.length;i++){
for(j=0;j<this.keyMap[i].length;j++){
t=this.keyMap[i][j][1];
if(this.typeMap[t]){
this.typeMap[t][this.keyMap[i][j][0]]=true;
}else{
this.typeMap[t]={};
}
this.reverseTypeMap[this.keyMap[i][j][0]]=t;
this.uHintMap[this.keyMap[i][j][0]]=this.keyMap[i][j][2];
}
}
}
Backend.prototype.getHint=function(_3c9,_3ca){
var _3cb;
for(var i=_3ca;i<_3c9.length;i++){
_3cb=_3c9.charAt(i);
if(_3cb!=this.nuktha&&_3cb!=this.halanth){
return this.uHintMap[_3cb];
}
}
return this.uHintMap[_3c9.charAt(0)];
};
Backend.prototype.getMathras=function(){
return this.mathras;
};
Backend.prototype.getClass=function(_3cd){
if(_3cd){
return this.reverseTypeMap[_3cd];
}
return "";
};
Backend.prototype.belongsTo=function(_3ce,_3cf){
if(this.typeMap[_3cf]&&this.typeMap[_3cf][_3ce]){
return true;
}
return false;
};
Backend.prototype.toAksharaList=function(ustr){
return ustr.match(this.pattern);
};
Backend.prototype.getKeyMap=function(){
var a=[];
MochiKit.Base.extend(a,this.keyMap);
return a;
};
Backend.prototype.getWord=function(_3d2,key){
var prev="^";
var _3d5;
if(_3d2.length>0){
_3d5=this.toAksharaList(_3d2);
prev=_3d5[_3d5.length-1];
}
var _3d6=prev+"+"+key;
var _3d7="#+"+key;
var row1=[];
if(this.interfaceMap[_3d7]){
row1=this.interfaceMap[_3d7];
}
var row2=[];
if(this.interfaceMap[_3d6]){
row2=this.interfaceMap[_3d6];
}
return [row1,row2];
};
Backend.prototype.getWordOptions=function(_3da,_3db){
var key=_3db.charAt(0);
var _3dd=[_3da+_3db];
if(_3da.length<0||_3da.charAt(_3da.length-1)!=this.halanth){
return _3dd;
}
if(this.belongsTo(key,"cons")){
if(this.zwjSignificant){
_3dd.push(_3da+this.zwjCode+_3db);
}
if(this.zwnjSignificant){
_3dd.push(_3da+this.zwnjCode+_3db);
}
}
return _3dd;
};
function backendExtraKeys(){
this.extraKeyMap="";
this.extraKeyMap=eval(["(","extra_keymap",")"].join(""));
}
(function(){
var _3de=window.jQuery,_$=window.$;
var _3e0=window.jQuery=window.$=function(_3e1,_3e2){
return new _3e0.fn.init(_3e1,_3e2);
};
var _3e3=/^[^<]*(<(.|\s)+>)[^>]*$|^#(\w+)$/,_3e4=/^.[^:#\[\.]*$/,_3e5;
_3e0.fn=_3e0.prototype={init:function(_3e6,_3e7){
_3e6=_3e6||document;
if(_3e6.nodeType){
this[0]=_3e6;
this.length=1;
return this;
}
if(typeof _3e6=="string"){
var _3e8=_3e3.exec(_3e6);
if(_3e8&&(_3e8[1]||!_3e7)){
if(_3e8[1]){
_3e6=_3e0.clean([_3e8[1]],_3e7);
}else{
var elem=document.getElementById(_3e8[3]);
if(elem){
if(elem.id!=_3e8[3]){
return _3e0().find(_3e6);
}
return _3e0(elem);
}
_3e6=[];
}
}else{
return _3e0(_3e7).find(_3e6);
}
}else{
if(_3e0.isFunction(_3e6)){
return _3e0(document)[_3e0.fn.ready?"ready":"load"](_3e6);
}
}
return this.setArray(_3e0.makeArray(_3e6));
},jquery:"1.2.6",size:function(){
return this.length;
},length:0,get:function(num){
return num==_3e5?_3e0.makeArray(this):this[num];
},pushStack:function(_3eb){
var ret=_3e0(_3eb);
ret.prevObject=this;
return ret;
},setArray:function(_3ed){
this.length=0;
Array.prototype.push.apply(this,_3ed);
return this;
},each:function(_3ee,args){
return _3e0.each(this,_3ee,args);
},index:function(elem){
var ret=-1;
return _3e0.inArray(elem&&elem.jquery?elem[0]:elem,this);
},attr:function(name,_3f3,type){
var _3f5=name;
if(name.constructor==String){
if(_3f3===_3e5){
return this[0]&&_3e0[type||"attr"](this[0],name);
}else{
_3f5={};
_3f5[name]=_3f3;
}
}
return this.each(function(i){
for(name in _3f5){
_3e0.attr(type?this.style:this,name,_3e0.prop(this,_3f5[name],type,i,name));
}
});
},css:function(key,_3f8){
if((key=="width"||key=="height")&&parseFloat(_3f8)<0){
_3f8=_3e5;
}
return this.attr(key,_3f8,"curCSS");
},text:function(text){
if(typeof text!="object"&&text!=null){
return this.empty().append((this[0]&&this[0].ownerDocument||document).createTextNode(text));
}
var ret="";
_3e0.each(text||this,function(){
_3e0.each(this.childNodes,function(){
if(this.nodeType!=8){
ret+=this.nodeType!=1?this.nodeValue:_3e0.fn.text([this]);
}
});
});
return ret;
},wrapAll:function(html){
if(this[0]){
_3e0(html,this[0].ownerDocument).clone().insertBefore(this[0]).map(function(){
var elem=this;
while(elem.firstChild){
elem=elem.firstChild;
}
return elem;
}).append(this);
}
return this;
},wrapInner:function(html){
return this.each(function(){
_3e0(this).contents().wrapAll(html);
});
},wrap:function(html){
return this.each(function(){
_3e0(this).wrapAll(html);
});
},append:function(){
return this.domManip(arguments,true,false,function(elem){
if(this.nodeType==1){
this.appendChild(elem);
}
});
},prepend:function(){
return this.domManip(arguments,true,true,function(elem){
if(this.nodeType==1){
this.insertBefore(elem,this.firstChild);
}
});
},before:function(){
return this.domManip(arguments,false,false,function(elem){
this.parentNode.insertBefore(elem,this);
});
},after:function(){
return this.domManip(arguments,false,true,function(elem){
this.parentNode.insertBefore(elem,this.nextSibling);
});
},end:function(){
return this.prevObject||_3e0([]);
},find:function(_403){
var _404=_3e0.map(this,function(elem){
return _3e0.find(_403,elem);
});
return this.pushStack(/[^+>] [^+>]/.test(_403)||_403.indexOf("..")>-1?_3e0.unique(_404):_404);
},clone:function(_406){
var ret=this.map(function(){
if(_3e0.browser.msie&&!_3e0.isXMLDoc(this)){
var _408=this.cloneNode(true),_409=document.createElement("div");
_409.appendChild(_408);
return _3e0.clean([_409.innerHTML])[0];
}else{
return this.cloneNode(true);
}
});
var _40a=ret.find("*").andSelf().each(function(){
if(this[expando]!=_3e5){
this[expando]=null;
}
});
if(_406===true){
this.find("*").andSelf().each(function(i){
if(this.nodeType==3){
return;
}
var _40c=_3e0.data(this,"events");
for(var type in _40c){
for(var _40e in _40c[type]){
_3e0.event.add(_40a[i],type,_40c[type][_40e],_40c[type][_40e].data);
}
}
});
}
return ret;
},filter:function(_40f){
return this.pushStack(_3e0.isFunction(_40f)&&_3e0.grep(this,function(elem,i){
return _40f.call(elem,i);
})||_3e0.multiFilter(_40f,this));
},not:function(_412){
if(_412.constructor==String){
if(_3e4.test(_412)){
return this.pushStack(_3e0.multiFilter(_412,this,true));
}else{
_412=_3e0.multiFilter(_412,this);
}
}
var _413=_412.length&&_412[_412.length-1]!==_3e5&&!_412.nodeType;
return this.filter(function(){
return _413?_3e0.inArray(this,_412)<0:this!=_412;
});
},add:function(_414){
return this.pushStack(_3e0.unique(_3e0.merge(this.get(),typeof _414=="string"?_3e0(_414):_3e0.makeArray(_414))));
},is:function(_415){
return !!_415&&_3e0.multiFilter(_415,this).length>0;
},hasClass:function(_416){
return this.is("."+_416);
},val:function(_417){
if(_417==_3e5){
if(this.length){
var elem=this[0];
if(_3e0.nodeName(elem,"select")){
var _419=elem.selectedIndex,_41a=[],_41b=elem.options,one=elem.type=="select-one";
if(_419<0){
return null;
}
for(var i=one?_419:0,max=one?_419+1:_41b.length;i<max;i++){
var _41f=_41b[i];
if(_41f.selected){
_417=_3e0.browser.msie&&!_41f.attributes.value.specified?_41f.text:_41f.value;
if(one){
return _417;
}
_41a.push(_417);
}
}
return _41a;
}else{
return (this[0].value||"").replace(/\r/g,"");
}
}
return _3e5;
}
if(_417.constructor==Number){
_417+="";
}
return this.each(function(){
if(this.nodeType!=1){
return;
}
if(_417.constructor==Array&&/radio|checkbox/.test(this.type)){
this.checked=(_3e0.inArray(this.value,_417)>=0||_3e0.inArray(this.name,_417)>=0);
}else{
if(_3e0.nodeName(this,"select")){
var _420=_3e0.makeArray(_417);
_3e0("option",this).each(function(){
this.selected=(_3e0.inArray(this.value,_420)>=0||_3e0.inArray(this.text,_420)>=0);
});
if(!_420.length){
this.selectedIndex=-1;
}
}else{
this.value=_417;
}
}
});
},html:function(_421){
return _421==_3e5?(this[0]?this[0].innerHTML:null):this.empty().append(_421);
},replaceWith:function(_422){
return this.after(_422).remove();
},eq:function(i){
return this.slice(i,i+1);
},slice:function(){
return this.pushStack(Array.prototype.slice.apply(this,arguments));
},map:function(_424){
return this.pushStack(_3e0.map(this,function(elem,i){
return _424.call(elem,i,elem);
}));
},andSelf:function(){
return this.add(this.prevObject);
},data:function(key,_428){
var _429=key.split(".");
_429[1]=_429[1]?"."+_429[1]:"";
if(_428===_3e5){
var data=this.triggerHandler("getData"+_429[1]+"!",[_429[0]]);
if(data===_3e5&&this.length){
data=_3e0.data(this[0],key);
}
return data===_3e5&&_429[1]?this.data(_429[0]):data;
}else{
return this.trigger("setData"+_429[1]+"!",[_429[0],_428]).each(function(){
_3e0.data(this,key,_428);
});
}
},removeData:function(key){
return this.each(function(){
_3e0.removeData(this,key);
});
},domManip:function(args,_42d,_42e,_42f){
var _430=this.length>1,_431;
return this.each(function(){
if(!_431){
_431=_3e0.clean(args,this.ownerDocument);
if(_42e){
_431.reverse();
}
}
var obj=this;
if(_42d&&_3e0.nodeName(this,"table")&&_3e0.nodeName(_431[0],"tr")){
obj=this.getElementsByTagName("tbody")[0]||this.appendChild(this.ownerDocument.createElement("tbody"));
}
var _433=_3e0([]);
_3e0.each(_431,function(){
var elem=_430?_3e0(this).clone(true)[0]:this;
if(_3e0.nodeName(elem,"script")){
_433=_433.add(elem);
}else{
if(elem.nodeType==1){
_433=_433.add(_3e0("script",elem).remove());
}
_42f.call(obj,elem);
}
});
_433.each(evalScript);
});
}};
_3e0.fn.init.prototype=_3e0.fn;
function evalScript(i,elem){
if(elem.src){
_3e0.ajax({url:elem.src,async:false,dataType:"script"});
}else{
_3e0.globalEval(elem.text||elem.textContent||elem.innerHTML||"");
}
if(elem.parentNode){
elem.parentNode.removeChild(elem);
}
}
function now(){
return +new Date;
}
_3e0.extend=_3e0.fn.extend=function(){
var _437=arguments[0]||{},i=1,_439=arguments.length,deep=false,_43b;
if(_437.constructor==Boolean){
deep=_437;
_437=arguments[1]||{};
i=2;
}
if(typeof _437!="object"&&typeof _437!="function"){
_437={};
}
if(_439==i){
_437=this;
--i;
}
for(;i<_439;i++){
if((_43b=arguments[i])!=null){
for(var name in _43b){
var src=_437[name],copy=_43b[name];
if(_437===copy){
continue;
}
if(deep&&copy&&typeof copy=="object"&&!copy.nodeType){
_437[name]=_3e0.extend(deep,src||(copy.length!=null?[]:{}),copy);
}else{
if(copy!==_3e5){
_437[name]=copy;
}
}
}
}
}
return _437;
};
var _43f="jQuery"+now(),uuid=0,_441={},_442=/z-?index|font-?weight|opacity|zoom|line-?height/i,_443=document.defaultView||{};
_3e0.extend({noConflict:function(deep){
window.$=_$;
if(deep){
window.jQuery=_3de;
}
return _3e0;
},isFunction:function(fn){
return !!fn&&typeof fn!="string"&&!fn.nodeName&&fn.constructor!=Array&&/^[\s[]?function/.test(fn+"");
},isXMLDoc:function(elem){
return elem.documentElement&&!elem.body||elem.tagName&&elem.ownerDocument&&!elem.ownerDocument.body;
},globalEval:function(data){
data=_3e0.trim(data);
if(data){
var head=document.getElementsByTagName("head")[0]||document.documentElement,_449=document.createElement("script");
_449.type="text/javascript";
if(_3e0.browser.msie){
_449.text=data;
}else{
_449.appendChild(document.createTextNode(data));
}
head.insertBefore(_449,head.firstChild);
head.removeChild(_449);
}
},nodeName:function(elem,name){
return elem.nodeName&&elem.nodeName.toUpperCase()==name.toUpperCase();
},cache:{},data:function(elem,name,data){
elem=elem==window?_441:elem;
var id=elem[_43f];
if(!id){
id=elem[_43f]=++uuid;
}
if(name&&!_3e0.cache[id]){
_3e0.cache[id]={};
}
if(data!==_3e5){
_3e0.cache[id][name]=data;
}
return name?_3e0.cache[id][name]:id;
},removeData:function(elem,name){
elem=elem==window?_441:elem;
var id=elem[_43f];
if(name){
if(_3e0.cache[id]){
delete _3e0.cache[id][name];
name="";
for(name in _3e0.cache[id]){
break;
}
if(!name){
_3e0.removeData(elem);
}
}
}else{
try{
delete elem[_43f];
}
catch(e){
if(elem.removeAttribute){
elem.removeAttribute(_43f);
}
}
delete _3e0.cache[id];
}
},each:function(_453,_454,args){
var name,i=0,_458=_453.length;
if(args){
if(_458==_3e5){
for(name in _453){
if(_454.apply(_453[name],args)===false){
break;
}
}
}else{
for(;i<_458;){
if(_454.apply(_453[i++],args)===false){
break;
}
}
}
}else{
if(_458==_3e5){
for(name in _453){
if(_454.call(_453[name],name,_453[name])===false){
break;
}
}
}else{
for(var _459=_453[0];i<_458&&_454.call(_459,i,_459)!==false;_459=_453[++i]){
}
}
}
return _453;
},prop:function(elem,_45b,type,i,name){
if(_3e0.isFunction(_45b)){
_45b=_45b.call(elem,i);
}
return _45b&&_45b.constructor==Number&&type=="curCSS"&&!_442.test(name)?_45b+"px":_45b;
},className:{add:function(elem,_460){
_3e0.each((_460||"").split(/\s+/),function(i,_462){
if(elem.nodeType==1&&!_3e0.className.has(elem.className,_462)){
elem.className+=(elem.className?" ":"")+_462;
}
});
},remove:function(elem,_464){
if(elem.nodeType==1){
elem.className=_464!=_3e5?_3e0.grep(elem.className.split(/\s+/),function(_465){
return !_3e0.className.has(_464,_465);
}).join(" "):"";
}
},has:function(elem,_467){
return _3e0.inArray(_467,(elem.className||elem).toString().split(/\s+/))>-1;
}},swap:function(elem,_469,_46a){
var old={};
for(var name in _469){
old[name]=elem.style[name];
elem.style[name]=_469[name];
}
_46a.call(elem);
for(var name in _469){
elem.style[name]=old[name];
}
},css:function(elem,name,_46f){
if(name=="width"||name=="height"){
var val,_471={position:"absolute",visibility:"hidden",display:"block"},_472=name=="width"?["Left","Right"]:["Top","Bottom"];
function getWH(){
val=name=="width"?elem.offsetWidth:elem.offsetHeight;
var _473=0,_474=0;
_3e0.each(_472,function(){
_473+=parseFloat(_3e0.curCSS(elem,"padding"+this,true))||0;
_474+=parseFloat(_3e0.curCSS(elem,"border"+this+"Width",true))||0;
});
val-=Math.round(_473+_474);
}
if(_3e0(elem).is(":visible")){
getWH();
}else{
_3e0.swap(elem,_471,getWH);
}
return Math.max(0,val);
}
return _3e0.curCSS(elem,name,_46f);
},curCSS:function(elem,name,_477){
var ret,_479=elem.style;
function color(elem){
if(!_3e0.browser.safari){
return false;
}
var ret=_443.getComputedStyle(elem,null);
return !ret||ret.getPropertyValue("color")=="";
}
if(name=="opacity"&&_3e0.browser.msie){
ret=_3e0.attr(_479,"opacity");
return ret==""?"1":ret;
}
if(_3e0.browser.opera&&name=="display"){
var save=_479.outline;
_479.outline="0 solid black";
_479.outline=save;
}
if(name.match(/float/i)){
name=styleFloat;
}
if(!_477&&_479&&_479[name]){
ret=_479[name];
}else{
if(_443.getComputedStyle){
if(name.match(/float/i)){
name="float";
}
name=name.replace(/([A-Z])/g,"-$1").toLowerCase();
var _47d=_443.getComputedStyle(elem,null);
if(_47d&&!color(elem)){
ret=_47d.getPropertyValue(name);
}else{
var swap=[],_47f=[],a=elem,i=0;
for(;a&&color(a);a=a.parentNode){
_47f.unshift(a);
}
for(;i<_47f.length;i++){
if(color(_47f[i])){
swap[i]=_47f[i].style.display;
_47f[i].style.display="block";
}
}
ret=name=="display"&&swap[_47f.length-1]!=null?"none":(_47d&&_47d.getPropertyValue(name))||"";
for(i=0;i<swap.length;i++){
if(swap[i]!=null){
_47f[i].style.display=swap[i];
}
}
}
if(name=="opacity"&&ret==""){
ret="1";
}
}else{
if(elem.currentStyle){
var _482=name.replace(/\-(\w)/g,function(all,_484){
return _484.toUpperCase();
});
ret=elem.currentStyle[name]||elem.currentStyle[_482];
if(!/^\d+(px)?$/i.test(ret)&&/^\d/.test(ret)){
var left=_479.left,_486=elem.runtimeStyle.left;
elem.runtimeStyle.left=elem.currentStyle.left;
_479.left=ret||0;
ret=_479.pixelLeft+"px";
_479.left=left;
elem.runtimeStyle.left=_486;
}
}
}
}
return ret;
},clean:function(_487,_488){
var ret=[];
_488=_488||document;
if(typeof _488.createElement=="undefined"){
_488=_488.ownerDocument||_488[0]&&_488[0].ownerDocument||document;
}
_3e0.each(_487,function(i,elem){
if(!elem){
return;
}
if(elem.constructor==Number){
elem+="";
}
if(typeof elem=="string"){
elem=elem.replace(/(<(\w+)[^>]*?)\/>/g,function(all,_48d,tag){
return tag.match(/^(abbr|br|col|img|input|link|meta|param|hr|area|embed)$/i)?all:_48d+"></"+tag+">";
});
var tags=_3e0.trim(elem).toLowerCase(),div=_488.createElement("div");
var wrap=!tags.indexOf("<opt")&&[1,"<select multiple='multiple'>","</select>"]||!tags.indexOf("<leg")&&[1,"<fieldset>","</fieldset>"]||tags.match(/^<(thead|tbody|tfoot|colg|cap)/)&&[1,"<table>","</table>"]||!tags.indexOf("<tr")&&[2,"<table><tbody>","</tbody></table>"]||(!tags.indexOf("<td")||!tags.indexOf("<th"))&&[3,"<table><tbody><tr>","</tr></tbody></table>"]||!tags.indexOf("<col")&&[2,"<table><tbody></tbody><colgroup>","</colgroup></table>"]||_3e0.browser.msie&&[1,"div<div>","</div>"]||[0,"",""];
div.innerHTML=wrap[1]+elem+wrap[2];
while(wrap[0]--){
div=div.lastChild;
}
if(_3e0.browser.msie){
var _492=!tags.indexOf("<table")&&tags.indexOf("<tbody")<0?div.firstChild&&div.firstChild.childNodes:wrap[1]=="<table>"&&tags.indexOf("<tbody")<0?div.childNodes:[];
for(var j=_492.length-1;j>=0;--j){
if(_3e0.nodeName(_492[j],"tbody")&&!_492[j].childNodes.length){
_492[j].parentNode.removeChild(_492[j]);
}
}
if(/^\s/.test(elem)){
div.insertBefore(_488.createTextNode(elem.match(/^\s*/)[0]),div.firstChild);
}
}
elem=_3e0.makeArray(div.childNodes);
}
if(elem.length===0&&(!_3e0.nodeName(elem,"form")&&!_3e0.nodeName(elem,"select"))){
return;
}
if(elem[0]==_3e5||_3e0.nodeName(elem,"form")||elem.options){
ret.push(elem);
}else{
ret=_3e0.merge(ret,elem);
}
});
return ret;
},attr:function(elem,name,_496){
if(!elem||elem.nodeType==3||elem.nodeType==8){
return _3e5;
}
var _497=!_3e0.isXMLDoc(elem),set=_496!==_3e5,msie=_3e0.browser.msie;
name=_497&&_3e0.props[name]||name;
if(elem.tagName){
var _49a=/href|src|style/.test(name);
if(name=="selected"&&_3e0.browser.safari){
elem.parentNode.selectedIndex;
}
if(name in elem&&_497&&!_49a){
if(set){
if(name=="type"&&_3e0.nodeName(elem,"input")&&elem.parentNode){
throw "type property can't be changed";
}
elem[name]=_496;
}
if(_3e0.nodeName(elem,"form")&&elem.getAttributeNode(name)){
return elem.getAttributeNode(name).nodeValue;
}
return elem[name];
}
if(msie&&_497&&name=="style"){
return _3e0.attr(elem.style,"cssText",_496);
}
if(set){
elem.setAttribute(name,""+_496);
}
var attr=msie&&_497&&_49a?elem.getAttribute(name,2):elem.getAttribute(name);
return attr===null?_3e5:attr;
}
if(msie&&name=="opacity"){
if(set){
elem.zoom=1;
elem.filter=(elem.filter||"").replace(/alpha\([^)]*\)/,"")+(parseInt(_496)+""=="NaN"?"":"alpha(opacity="+_496*100+")");
}
return elem.filter&&elem.filter.indexOf("opacity=")>=0?(parseFloat(elem.filter.match(/opacity=([^)]*)/)[1])/100)+"":"";
}
name=name.replace(/-([a-z])/ig,function(all,_49d){
return _49d.toUpperCase();
});
if(set){
elem[name]=_496;
}
return elem[name];
},trim:function(text){
return (text||"").replace(/^\s+|\s+$/g,"");
},makeArray:function(_49f){
var ret=[];
if(_49f!=null){
var i=_49f.length;
if(i==null||_49f.split||_49f.setInterval||_49f.call){
ret[0]=_49f;
}else{
while(i){
ret[--i]=_49f[i];
}
}
}
return ret;
},inArray:function(elem,_4a3){
for(var i=0,_4a5=_4a3.length;i<_4a5;i++){
if(_4a3[i]===elem){
return i;
}
}
return -1;
},merge:function(_4a6,_4a7){
var i=0,elem,pos=_4a6.length;
if(_3e0.browser.msie){
while(elem=_4a7[i++]){
if(elem.nodeType!=8){
_4a6[pos++]=elem;
}
}
}else{
while(elem=_4a7[i++]){
_4a6[pos++]=elem;
}
}
return _4a6;
},unique:function(_4ab){
var ret=[],done={};
try{
for(var i=0,_4af=_4ab.length;i<_4af;i++){
var id=_3e0.data(_4ab[i]);
if(!done[id]){
done[id]=true;
ret.push(_4ab[i]);
}
}
}
catch(e){
ret=_4ab;
}
return ret;
},grep:function(_4b1,_4b2,inv){
var ret=[];
for(var i=0,_4b6=_4b1.length;i<_4b6;i++){
if(!inv!=!_4b2(_4b1[i],i)){
ret.push(_4b1[i]);
}
}
return ret;
},map:function(_4b7,_4b8){
var ret=[];
for(var i=0,_4bb=_4b7.length;i<_4bb;i++){
var _4bc=_4b8(_4b7[i],i);
if(_4bc!=null){
ret[ret.length]=_4bc;
}
}
return ret.concat.apply([],ret);
}});
var _4bd=navigator.userAgent.toLowerCase();
_3e0.browser={version:(_4bd.match(/.+(?:rv|it|ra|ie)[\/: ]([\d.]+)/)||[])[1],safari:/webkit/.test(_4bd),opera:/opera/.test(_4bd),msie:/msie/.test(_4bd)&&!/opera/.test(_4bd),mozilla:/mozilla/.test(_4bd)&&!/(compatible|webkit)/.test(_4bd)};
var _4be=_3e0.browser.msie?"styleFloat":"cssFloat";
_3e0.extend({boxModel:!_3e0.browser.msie||document.compatMode=="CSS1Compat",props:{"for":"htmlFor","class":"className","float":_4be,cssFloat:_4be,styleFloat:_4be,readonly:"readOnly",maxlength:"maxLength",cellspacing:"cellSpacing"}});
_3e0.each({parent:function(elem){
return elem.parentNode;
},parents:function(elem){
return _3e0.dir(elem,"parentNode");
},next:function(elem){
return _3e0.nth(elem,2,"nextSibling");
},prev:function(elem){
return _3e0.nth(elem,2,"previousSibling");
},nextAll:function(elem){
return _3e0.dir(elem,"nextSibling");
},prevAll:function(elem){
return _3e0.dir(elem,"previousSibling");
},siblings:function(elem){
return _3e0.sibling(elem.parentNode.firstChild,elem);
},children:function(elem){
return _3e0.sibling(elem.firstChild);
},contents:function(elem){
return _3e0.nodeName(elem,"iframe")?elem.contentDocument||elem.contentWindow.document:_3e0.makeArray(elem.childNodes);
}},function(name,fn){
_3e0.fn[name]=function(_4ca){
var ret=_3e0.map(this,fn);
if(_4ca&&typeof _4ca=="string"){
ret=_3e0.multiFilter(_4ca,ret);
}
return this.pushStack(_3e0.unique(ret));
};
});
_3e0.each({appendTo:"append",prependTo:"prepend",insertBefore:"before",insertAfter:"after",replaceAll:"replaceWith"},function(name,_4cd){
_3e0.fn[name]=function(){
var args=arguments;
return this.each(function(){
for(var i=0,_4d0=args.length;i<_4d0;i++){
_3e0(args[i])[_4cd](this);
}
});
};
});
_3e0.each({removeAttr:function(name){
_3e0.attr(this,name,"");
if(this.nodeType==1){
this.removeAttribute(name);
}
},addClass:function(_4d2){
_3e0.className.add(this,_4d2);
},removeClass:function(_4d3){
_3e0.className.remove(this,_4d3);
},toggleClass:function(_4d4){
_3e0.className[_3e0.className.has(this,_4d4)?"remove":"add"](this,_4d4);
},remove:function(_4d5){
if(!_4d5||_3e0.filter(_4d5,[this]).r.length){
_3e0("*",this).add(this).each(function(){
_3e0.event.remove(this);
_3e0.removeData(this);
});
if(this.parentNode){
this.parentNode.removeChild(this);
}
}
},empty:function(){
_3e0(">*",this).remove();
while(this.firstChild){
this.removeChild(this.firstChild);
}
}},function(name,fn){
_3e0.fn[name]=function(){
return this.each(fn,arguments);
};
});
_3e0.each(["Height","Width"],function(i,name){
var type=name.toLowerCase();
_3e0.fn[type]=function(size){
return this[0]==window?_3e0.browser.opera&&document.body["client"+name]||_3e0.browser.safari&&window["inner"+name]||document.compatMode=="CSS1Compat"&&document.documentElement["client"+name]||document.body["client"+name]:this[0]==document?Math.max(Math.max(document.body["scroll"+name],document.documentElement["scroll"+name]),Math.max(document.body["offset"+name],document.documentElement["offset"+name])):size==_3e5?(this.length?_3e0.css(this[0],type):null):this.css(type,size.constructor==String?size:size+"px");
};
});
function num(elem,prop){
return elem[0]&&parseInt(_3e0.curCSS(elem[0],prop,true),10)||0;
}
var _4de=_3e0.browser.safari&&parseInt(_3e0.browser.version)<417?"(?:[\\w*_-]|\\\\.)":"(?:[\\w\u0128-\uffff*_-]|\\\\.)",_4df=new RegExp("^>\\s*("+_4de+"+)"),_4e0=new RegExp("^("+_4de+"+)(#)("+_4de+"+)"),_4e1=new RegExp("^([#.]?)("+_4de+"*)");
_3e0.extend({expr:{"":function(a,i,m){
return m[2]=="*"||_3e0.nodeName(a,m[2]);
},"#":function(a,i,m){
return a.getAttribute("id")==m[2];
},":":{lt:function(a,i,m){
return i<m[3]-0;
},gt:function(a,i,m){
return i>m[3]-0;
},nth:function(a,i,m){
return m[3]-0==i;
},eq:function(a,i,m){
return m[3]-0==i;
},first:function(a,i){
return i==0;
},last:function(a,i,m,r){
return i==r.length-1;
},even:function(a,i){
return i%2==0;
},odd:function(a,i){
return i%2;
},"first-child":function(a){
return a.parentNode.getElementsByTagName("*")[0]==a;
},"last-child":function(a){
return _3e0.nth(a.parentNode.lastChild,1,"previousSibling")==a;
},"only-child":function(a){
return !_3e0.nth(a.parentNode.lastChild,2,"previousSibling");
},parent:function(a){
return a.firstChild;
},empty:function(a){
return !a.firstChild;
},contains:function(a,i,m){
return (a.textContent||a.innerText||_3e0(a).text()||"").indexOf(m[3])>=0;
},visible:function(a){
return "hidden"!=a.type&&_3e0.css(a,"display")!="none"&&_3e0.css(a,"visibility")!="hidden";
},hidden:function(a){
return "hidden"==a.type||_3e0.css(a,"display")=="none"||_3e0.css(a,"visibility")=="hidden";
},enabled:function(a){
return !a.disabled;
},disabled:function(a){
return a.disabled;
},checked:function(a){
return a.checked;
},selected:function(a){
return a.selected||_3e0.attr(a,"selected");
},text:function(a){
return "text"==a.type;
},radio:function(a){
return "radio"==a.type;
},checkbox:function(a){
return "checkbox"==a.type;
},file:function(a){
return "file"==a.type;
},password:function(a){
return "password"==a.type;
},submit:function(a){
return "submit"==a.type;
},image:function(a){
return "image"==a.type;
},reset:function(a){
return "reset"==a.type;
},button:function(a){
return "button"==a.type||_3e0.nodeName(a,"button");
},input:function(a){
return /input|select|textarea|button/i.test(a.nodeName);
},has:function(a,i,m){
return _3e0.find(m[3],a).length;
},header:function(a){
return /h\d/i.test(a.nodeName);
},animated:function(a){
return _3e0.grep(_3e0.timers,function(fn){
return a==fn.elem;
}).length;
}}},parse:[/^(\[) *@?([\w-]+) *([!*$^~=]*) *('?"?)(.*?)\4 *\]/,/^(:)([\w-]+)\("?'?(.*?(\(.*?\))?[^(]*?)"?'?\)/,new RegExp("^([:.#]*)("+_4de+"+)")],multiFilter:function(expr,_51d,not){
var old,cur=[];
while(expr&&expr!=old){
old=expr;
var f=_3e0.filter(expr,_51d,not);
expr=f.t.replace(/^\s*,\s*/,"");
cur=not?_51d=f.r:_3e0.merge(cur,f.r);
}
return cur;
},find:function(t,_523){
if(typeof t!="string"){
return [t];
}
if(_523&&_523.nodeType!=1&&_523.nodeType!=9){
return [];
}
_523=_523||document;
var ret=[_523],done=[],last,_527;
while(t&&last!=t){
var r=[];
last=t;
t=_3e0.trim(t);
var _529=false,re=_4df,m=re.exec(t);
if(m){
_527=m[1].toUpperCase();
for(var i=0;ret[i];i++){
for(var c=ret[i].firstChild;c;c=c.nextSibling){
if(c.nodeType==1&&(_527=="*"||c.nodeName.toUpperCase()==_527)){
r.push(c);
}
}
}
ret=r;
t=t.replace(re,"");
if(t.indexOf(" ")==0){
continue;
}
_529=true;
}else{
re=/^([>+~])\s*(\w*)/i;
if((m=re.exec(t))!=null){
r=[];
var _52e={};
_527=m[2].toUpperCase();
m=m[1];
for(var j=0,rl=ret.length;j<rl;j++){
var n=m=="~"||m=="+"?ret[j].nextSibling:ret[j].firstChild;
for(;n;n=n.nextSibling){
if(n.nodeType==1){
var id=_3e0.data(n);
if(m=="~"&&_52e[id]){
break;
}
if(!_527||n.nodeName.toUpperCase()==_527){
if(m=="~"){
_52e[id]=true;
}
r.push(n);
}
if(m=="+"){
break;
}
}
}
}
ret=r;
t=_3e0.trim(t.replace(re,""));
_529=true;
}
}
if(t&&!_529){
if(!t.indexOf(",")){
if(_523==ret[0]){
ret.shift();
}
done=_3e0.merge(done,ret);
r=ret=[_523];
t=" "+t.substr(1,t.length);
}else{
var re2=_4e0;
var m=re2.exec(t);
if(m){
m=[0,m[2],m[3],m[1]];
}else{
re2=_4e1;
m=re2.exec(t);
}
m[2]=m[2].replace(/\\/g,"");
var elem=ret[ret.length-1];
if(m[1]=="#"&&elem&&elem.getElementById&&!_3e0.isXMLDoc(elem)){
var oid=elem.getElementById(m[2]);
if((_3e0.browser.msie||_3e0.browser.opera)&&oid&&typeof oid.id=="string"&&oid.id!=m[2]){
oid=_3e0("[@id=\""+m[2]+"\"]",elem)[0];
}
ret=r=oid&&(!m[3]||_3e0.nodeName(oid,m[3]))?[oid]:[];
}else{
for(var i=0;ret[i];i++){
var tag=m[1]=="#"&&m[3]?m[3]:m[1]!=""||m[0]==""?"*":m[2];
if(tag=="*"&&ret[i].nodeName.toLowerCase()=="object"){
tag="param";
}
r=_3e0.merge(r,ret[i].getElementsByTagName(tag));
}
if(m[1]=="."){
r=_3e0.classFilter(r,m[2]);
}
if(m[1]=="#"){
var tmp=[];
for(var i=0;r[i];i++){
if(r[i].getAttribute("id")==m[2]){
tmp=[r[i]];
break;
}
}
r=tmp;
}
ret=r;
}
t=t.replace(re2,"");
}
}
if(t){
var val=_3e0.filter(t,r);
ret=r=val.r;
t=_3e0.trim(val.t);
}
}
if(t){
ret=[];
}
if(ret&&_523==ret[0]){
ret.shift();
}
done=_3e0.merge(done,ret);
return done;
},classFilter:function(r,m,not){
m=" "+m+" ";
var tmp=[];
for(var i=0;r[i];i++){
var pass=(" "+r[i].className+" ").indexOf(m)>=0;
if(!not&&pass||not&&!pass){
tmp.push(r[i]);
}
}
return tmp;
},filter:function(t,r,not){
var last;
while(t&&t!=last){
last=t;
var p=_3e0.parse,m;
for(var i=0;p[i];i++){
m=p[i].exec(t);
if(m){
t=t.substring(m[0].length);
m[2]=m[2].replace(/\\/g,"");
break;
}
}
if(!m){
break;
}
if(m[1]==":"&&m[2]=="not"){
r=_3e4.test(m[3])?_3e0.filter(m[3],r,true).r:_3e0(r).not(m[3]);
}else{
if(m[1]=="."){
r=_3e0.classFilter(r,m[2],not);
}else{
if(m[1]=="["){
var tmp=[],type=m[3];
for(var i=0,rl=r.length;i<rl;i++){
var a=r[i],z=a[_3e0.props[m[2]]||m[2]];
if(z==null||/href|src|selected/.test(m[2])){
z=_3e0.attr(a,m[2])||"";
}
if((type==""&&!!z||type=="="&&z==m[5]||type=="!="&&z!=m[5]||type=="^="&&z&&!z.indexOf(m[5])||type=="$="&&z.substr(z.length-m[5].length)==m[5]||(type=="*="||type=="~=")&&z.indexOf(m[5])>=0)^not){
tmp.push(a);
}
}
r=tmp;
}else{
if(m[1]==":"&&m[2]=="nth-child"){
var _54b={},tmp=[],test=/(-?)(\d*)n((?:\+|-)?\d*)/.exec(m[3]=="even"&&"2n"||m[3]=="odd"&&"2n+1"||!/\D/.test(m[3])&&"0n+"+m[3]||m[3]),_54d=(test[1]+(test[2]||1))-0,last=test[3]-0;
for(var i=0,rl=r.length;i<rl;i++){
var node=r[i],_54f=node.parentNode,id=_3e0.data(_54f);
if(!_54b[id]){
var c=1;
for(var n=_54f.firstChild;n;n=n.nextSibling){
if(n.nodeType==1){
n.nodeIndex=c++;
}
}
_54b[id]=true;
}
var add=false;
if(_54d==0){
if(node.nodeIndex==last){
add=true;
}
}else{
if((node.nodeIndex-last)%_54d==0&&(node.nodeIndex-last)/_54d>=0){
add=true;
}
}
if(add^not){
tmp.push(node);
}
}
r=tmp;
}else{
var fn=_3e0.expr[m[1]];
if(typeof fn=="object"){
fn=fn[m[2]];
}
if(typeof fn=="string"){
fn=eval("false||function(a,i){return "+fn+";}");
}
r=_3e0.grep(r,function(elem,i){
return fn(elem,i,m,r);
},not);
}
}
}
}
}
return {r:r,t:t};
},dir:function(elem,dir){
var _559=[],cur=elem[dir];
while(cur&&cur!=document){
if(cur.nodeType==1){
_559.push(cur);
}
cur=cur[dir];
}
return _559;
},nth:function(cur,_55c,dir,elem){
_55c=_55c||1;
var num=0;
for(;cur;cur=cur[dir]){
if(cur.nodeType==1&&++num==_55c){
break;
}
}
return cur;
},sibling:function(n,elem){
var r=[];
for(;n;n=n.nextSibling){
if(n.nodeType==1&&n!=elem){
r.push(n);
}
}
return r;
}});
_3e0.event={add:function(elem,_564,_565,data){
if(elem.nodeType==3||elem.nodeType==8){
return;
}
if(_3e0.browser.msie&&elem.setInterval){
elem=window;
}
if(!_565.guid){
_565.guid=this.guid++;
}
if(data!=_3e5){
var fn=_565;
_565=this.proxy(fn,function(){
return fn.apply(this,arguments);
});
_565.data=data;
}
var _568=_3e0.data(elem,"events")||_3e0.data(elem,"events",{}),_569=_3e0.data(elem,"handle")||_3e0.data(elem,"handle",function(){
if(typeof _3e0!="undefined"&&!_3e0.event.triggered){
return _3e0.event.handle.apply(arguments.callee.elem,arguments);
}
});
_569.elem=elem;
_3e0.each(_564.split(/\s+/),function(_56a,type){
var _56c=type.split(".");
type=_56c[0];
_565.type=_56c[1];
var _56d=_568[type];
if(!_56d){
_56d=_568[type]={};
if(!_3e0.event.special[type]||_3e0.event.special[type].setup.call(elem)===false){
if(elem.addEventListener){
elem.addEventListener(type,_569,false);
}else{
if(elem.attachEvent){
elem.attachEvent("on"+type,_569);
}
}
}
}
_56d[_565.guid]=_565;
_3e0.event.global[type]=true;
});
elem=null;
},guid:1,global:{},remove:function(elem,_56f,_570){
if(elem.nodeType==3||elem.nodeType==8){
return;
}
var _571=_3e0.data(elem,"events"),ret,_573;
if(_571){
if(_56f==_3e5||(typeof _56f=="string"&&_56f.charAt(0)==".")){
for(var type in _571){
this.remove(elem,type+(_56f||""));
}
}else{
if(_56f.type){
_570=_56f.handler;
_56f=_56f.type;
}
_3e0.each(_56f.split(/\s+/),function(_575,type){
var _577=type.split(".");
type=_577[0];
if(_571[type]){
if(_570){
delete _571[type][_570.guid];
}else{
for(_570 in _571[type]){
if(!_577[1]||_571[type][_570].type==_577[1]){
delete _571[type][_570];
}
}
}
for(ret in _571[type]){
break;
}
if(!ret){
if(!_3e0.event.special[type]||_3e0.event.special[type].teardown.call(elem)===false){
if(elem.removeEventListener){
elem.removeEventListener(type,_3e0.data(elem,"handle"),false);
}else{
if(elem.detachEvent){
elem.detachEvent("on"+type,_3e0.data(elem,"handle"));
}
}
}
ret=null;
delete _571[type];
}
}
});
}
for(ret in _571){
break;
}
if(!ret){
var _578=_3e0.data(elem,"handle");
if(_578){
_578.elem=null;
}
_3e0.removeData(elem,"events");
_3e0.removeData(elem,"handle");
}
}
},trigger:function(type,data,elem,_57c,_57d){
data=_3e0.makeArray(data);
if(type.indexOf("!")>=0){
type=type.slice(0,-1);
var _57e=true;
}
if(!elem){
if(this.global[type]){
_3e0("*").add([window,document]).trigger(type,data);
}
}else{
if(elem.nodeType==3||elem.nodeType==8){
return _3e5;
}
var val,ret,fn=_3e0.isFunction(elem[type]||null),_582=!data[0]||!data[0].preventDefault;
if(_582){
data.unshift({type:type,target:elem,preventDefault:function(){
},stopPropagation:function(){
},timeStamp:now()});
data[0][_43f]=true;
}
data[0].type=type;
if(_57e){
data[0].exclusive=true;
}
var _583=_3e0.data(elem,"handle");
if(_583){
val=_583.apply(elem,data);
}
if((!fn||(_3e0.nodeName(elem,"a")&&type=="click"))&&elem["on"+type]&&elem["on"+type].apply(elem,data)===false){
val=false;
}
if(_582){
data.shift();
}
if(_57d&&_3e0.isFunction(_57d)){
ret=_57d.apply(elem,val==null?data:data.concat(val));
if(ret!==_3e5){
val=ret;
}
}
if(fn&&_57c!==false&&val!==false&&!(_3e0.nodeName(elem,"a")&&type=="click")){
this.triggered=true;
try{
elem[type]();
}
catch(e){
}
}
this.triggered=false;
}
return val;
},handle:function(_584){
var val,ret,_587,all,_589;
_584=arguments[0]=_3e0.event.fix(_584||window.event);
_587=_584.type.split(".");
_584.type=_587[0];
_587=_587[1];
all=!_587&&!_584.exclusive;
_589=(_3e0.data(this,"events")||{})[_584.type];
for(var j in _589){
var _58b=_589[j];
if(all||_58b.type==_587){
_584.handler=_58b;
_584.data=_58b.data;
ret=_58b.apply(this,arguments);
if(val!==false){
val=ret;
}
if(ret===false){
_584.preventDefault();
_584.stopPropagation();
}
}
}
return val;
},fix:function(_58c){
if(_58c[_43f]==true){
return _58c;
}
var _58d=_58c;
_58c={originalEvent:_58d};
var _58e="altKey attrChange attrName bubbles button cancelable charCode clientX clientY ctrlKey currentTarget data detail eventPhase fromElement handler keyCode metaKey newValue originalTarget pageX pageY prevValue relatedNode relatedTarget screenX screenY shiftKey srcElement target timeStamp toElement type view wheelDelta which".split(" ");
for(var i=_58e.length;i;i--){
_58c[_58e[i]]=_58d[_58e[i]];
}
_58c[_43f]=true;
_58c.preventDefault=function(){
if(_58d.preventDefault){
_58d.preventDefault();
}
_58d.returnValue=false;
};
_58c.stopPropagation=function(){
if(_58d.stopPropagation){
_58d.stopPropagation();
}
_58d.cancelBubble=true;
};
_58c.timeStamp=_58c.timeStamp||now();
if(!_58c.target){
_58c.target=_58c.srcElement||document;
}
if(_58c.target.nodeType==3){
_58c.target=_58c.target.parentNode;
}
if(!_58c.relatedTarget&&_58c.fromElement){
_58c.relatedTarget=_58c.fromElement==_58c.target?_58c.toElement:_58c.fromElement;
}
if(_58c.pageX==null&&_58c.clientX!=null){
var doc=document.documentElement,body=document.body;
_58c.pageX=_58c.clientX+(doc&&doc.scrollLeft||body&&body.scrollLeft||0)-(doc.clientLeft||0);
_58c.pageY=_58c.clientY+(doc&&doc.scrollTop||body&&body.scrollTop||0)-(doc.clientTop||0);
}
if(!_58c.which&&((_58c.charCode||_58c.charCode===0)?_58c.charCode:_58c.keyCode)){
_58c.which=_58c.charCode||_58c.keyCode;
}
if(!_58c.metaKey&&_58c.ctrlKey){
_58c.metaKey=_58c.ctrlKey;
}
if(!_58c.which&&_58c.button){
_58c.which=(_58c.button&1?1:(_58c.button&2?3:(_58c.button&4?2:0)));
}
return _58c;
},proxy:function(fn,_593){
_593.guid=fn.guid=fn.guid||_593.guid||this.guid++;
return _593;
},special:{ready:{setup:function(){
bindReady();
return;
},teardown:function(){
return;
}},mouseenter:{setup:function(){
if(_3e0.browser.msie){
return false;
}
_3e0(this).bind("mouseover",_3e0.event.special.mouseenter.handler);
return true;
},teardown:function(){
if(_3e0.browser.msie){
return false;
}
_3e0(this).unbind("mouseover",_3e0.event.special.mouseenter.handler);
return true;
},handler:function(_594){
if(_595(_594,this)){
return true;
}
_594.type="mouseenter";
return _3e0.event.handle.apply(this,arguments);
}},mouseleave:{setup:function(){
if(_3e0.browser.msie){
return false;
}
_3e0(this).bind("mouseout",_3e0.event.special.mouseleave.handler);
return true;
},teardown:function(){
if(_3e0.browser.msie){
return false;
}
_3e0(this).unbind("mouseout",_3e0.event.special.mouseleave.handler);
return true;
},handler:function(_596){
if(_595(_596,this)){
return true;
}
_596.type="mouseleave";
return _3e0.event.handle.apply(this,arguments);
}}}};
_3e0.fn.extend({bind:function(type,data,fn){
return type=="unload"?this.one(type,data,fn):this.each(function(){
_3e0.event.add(this,type,fn||data,fn&&data);
});
},one:function(type,data,fn){
var one=_3e0.event.proxy(fn||data,function(_59e){
_3e0(this).unbind(_59e,one);
return (fn||data).apply(this,arguments);
});
return this.each(function(){
_3e0.event.add(this,type,one,fn&&data);
});
},unbind:function(type,fn){
return this.each(function(){
_3e0.event.remove(this,type,fn);
});
},trigger:function(type,data,fn){
return this.each(function(){
_3e0.event.trigger(type,data,this,true,fn);
});
},triggerHandler:function(type,data,fn){
return this[0]&&_3e0.event.trigger(type,data,this[0],false,fn);
},toggle:function(fn){
var args=arguments,i=1;
while(i<args.length){
_3e0.event.proxy(fn,args[i++]);
}
return this.click(_3e0.event.proxy(fn,function(_5aa){
this.lastToggle=(this.lastToggle||0)%i;
_5aa.preventDefault();
return args[this.lastToggle++].apply(this,arguments)||false;
}));
},hover:function(_5ab,_5ac){
return this.bind("mouseenter",_5ab).bind("mouseleave",_5ac);
},ready:function(fn){
bindReady();
if(_3e0.isReady){
fn.call(document,_3e0);
}else{
_3e0.readyList.push(function(){
return fn.call(this,_3e0);
});
}
return this;
}});
_3e0.extend({isReady:false,readyList:[],ready:function(){
if(!_3e0.isReady){
_3e0.isReady=true;
if(_3e0.readyList){
_3e0.each(_3e0.readyList,function(){
this.call(document);
});
_3e0.readyList=null;
}
_3e0(document).triggerHandler("ready");
}
}});
var _5ae=false;
function bindReady(){
if(_5ae){
return;
}
_5ae=true;
if(document.addEventListener&&!_3e0.browser.opera){
document.addEventListener("DOMContentLoaded",_3e0.ready,false);
}
if(_3e0.browser.msie&&window==top){
(function(){
if(_3e0.isReady){
return;
}
try{
document.documentElement.doScroll("left");
}
catch(error){
setTimeout(arguments.callee,0);
return;
}
_3e0.ready();
})();
}
if(_3e0.browser.opera){
document.addEventListener("DOMContentLoaded",function(){
if(_3e0.isReady){
return;
}
for(var i=0;i<document.styleSheets.length;i++){
if(document.styleSheets[i].disabled){
setTimeout(arguments.callee,0);
return;
}
}
_3e0.ready();
},false);
}
if(_3e0.browser.safari){
var _5b0;
(function(){
if(_3e0.isReady){
return;
}
if(document.readyState!="loaded"&&document.readyState!="complete"){
setTimeout(arguments.callee,0);
return;
}
if(_5b0===_3e5){
_5b0=_3e0("style, link[rel=stylesheet]").length;
}
if(document.styleSheets.length!=_5b0){
setTimeout(arguments.callee,0);
return;
}
_3e0.ready();
})();
}
_3e0.event.add(window,"load",_3e0.ready);
}
_3e0.each(("blur,focus,load,resize,scroll,unload,click,dblclick,"+"mousedown,mouseup,mousemove,mouseover,mouseout,change,select,"+"submit,keydown,keypress,keyup,error").split(","),function(i,name){
_3e0.fn[name]=function(fn){
return fn?this.bind(name,fn):this.trigger(name);
};
});
var _595=function(_5b4,elem){
var _5b6=_5b4.relatedTarget;
while(_5b6&&_5b6!=elem){
try{
_5b6=_5b6.parentNode;
}
catch(error){
_5b6=elem;
}
}
return _5b6==elem;
};
_3e0(window).bind("unload",function(){
_3e0("*").add(document).unbind();
});
_3e0.fn.extend({_load:_3e0.fn.load,load:function(url,_5b8,_5b9){
if(typeof url!="string"){
return this._load(url);
}
var off=url.indexOf(" ");
if(off>=0){
var _5bb=url.slice(off,url.length);
url=url.slice(0,off);
}
_5b9=_5b9||function(){
};
var type="GET";
if(_5b8){
if(_3e0.isFunction(_5b8)){
_5b9=_5b8;
_5b8=null;
}else{
_5b8=_3e0.param(_5b8);
type="POST";
}
}
var self=this;
_3e0.ajax({url:url,type:type,dataType:"html",data:_5b8,complete:function(res,_5bf){
if(_5bf=="success"||_5bf=="notmodified"){
self.html(_5bb?_3e0("<div/>").append(res.responseText.replace(/<script(.|\s)*?\/script>/g,"")).find(_5bb):res.responseText);
}
self.each(_5b9,[res.responseText,_5bf,res]);
}});
return this;
},serialize:function(){
return _3e0.param(this.serializeArray());
},serializeArray:function(){
return this.map(function(){
return _3e0.nodeName(this,"form")?_3e0.makeArray(this.elements):this;
}).filter(function(){
return this.name&&!this.disabled&&(this.checked||/select|textarea/i.test(this.nodeName)||/text|hidden|password/i.test(this.type));
}).map(function(i,elem){
var val=_3e0(this).val();
return val==null?null:val.constructor==Array?_3e0.map(val,function(val,i){
return {name:elem.name,value:val};
}):{name:elem.name,value:val};
}).get();
}});
_3e0.each("ajaxStart,ajaxStop,ajaxComplete,ajaxError,ajaxSuccess,ajaxSend".split(","),function(i,o){
_3e0.fn[o]=function(f){
return this.bind(o,f);
};
});
var jsc=now();
_3e0.extend({get:function(url,data,_5cb,type){
if(_3e0.isFunction(data)){
_5cb=data;
data=null;
}
return _3e0.ajax({type:"GET",url:url,data:data,success:_5cb,dataType:type});
},getScript:function(url,_5ce){
return _3e0.get(url,null,_5ce,"script");
},getJSON:function(url,data,_5d1){
return _3e0.get(url,data,_5d1,"json");
},post:function(url,data,_5d4,type){
if(_3e0.isFunction(data)){
_5d4=data;
data={};
}
return _3e0.ajax({type:"POST",url:url,data:data,success:_5d4,dataType:type});
},ajaxSetup:function(_5d6){
_3e0.extend(_3e0.ajaxSettings,_5d6);
},ajaxSettings:{url:location.href,global:true,type:"GET",timeout:0,contentType:"application/x-www-form-urlencoded",processData:true,async:true,data:null,username:null,password:null,accepts:{xml:"application/xml, text/xml",html:"text/html",script:"text/javascript, application/javascript",json:"application/json, text/javascript",text:"text/plain",_default:"*/*"}},lastModified:{},ajax:function(s){
s=_3e0.extend(true,s,_3e0.extend(true,{},_3e0.ajaxSettings,s));
var _5d8,jsre=/=\?(&|$)/g,_5da,data,type=s.type.toUpperCase();
if(s.data&&s.processData&&typeof s.data!="string"){
s.data=_3e0.param(s.data);
}
if(s.dataType=="jsonp"){
if(type=="GET"){
if(!s.url.match(jsre)){
s.url+=(s.url.match(/\?/)?"&":"?")+(s.jsonp||"callback")+"=?";
}
}else{
if(!s.data||!s.data.match(jsre)){
s.data=(s.data?s.data+"&":"")+(s.jsonp||"callback")+"=?";
}
}
s.dataType="json";
}
if(s.dataType=="json"&&(s.data&&s.data.match(jsre)||s.url.match(jsre))){
_5d8="jsonp"+jsc++;
if(s.data){
s.data=(s.data+"").replace(jsre,"="+_5d8+"$1");
}
s.url=s.url.replace(jsre,"="+_5d8+"$1");
s.dataType="script";
window[_5d8]=function(tmp){
data=tmp;
success();
complete();
window[_5d8]=_3e5;
try{
delete window[_5d8];
}
catch(e){
}
if(head){
head.removeChild(_5df);
}
};
}
if(s.dataType=="script"&&s.cache==null){
s.cache=false;
}
if(s.cache===false&&type=="GET"){
var ts=now();
var ret=s.url.replace(/(\?|&)_=.*?(&|$)/,"$1_="+ts+"$2");
s.url=ret+((ret==s.url)?(s.url.match(/\?/)?"&":"?")+"_="+ts:"");
}
if(s.data&&type=="GET"){
s.url+=(s.url.match(/\?/)?"&":"?")+s.data;
s.data=null;
}
if(s.global&&!_3e0.active++){
_3e0.event.trigger("ajaxStart");
}
var _5e2=/^(?:\w+:)?\/\/([^\/?#]+)/;
if(s.dataType=="script"&&type=="GET"&&_5e2.test(s.url)&&_5e2.exec(s.url)[1]!=location.host){
var head=document.getElementsByTagName("head")[0];
var _5df=document.createElement("script");
_5df.src=s.url;
if(s.scriptCharset){
_5df.charset=s.scriptCharset;
}
if(!_5d8){
var done=false;
_5df.onload=_5df.onreadystatechange=function(){
if(!done&&(!this.readyState||this.readyState=="loaded"||this.readyState=="complete")){
done=true;
success();
complete();
head.removeChild(_5df);
}
};
}
head.appendChild(_5df);
return _3e5;
}
var _5e4=false;
var xhr=window.ActiveXObject?new ActiveXObject("Microsoft.XMLHTTP"):new XMLHttpRequest();
if(s.username){
xhr.open(type,s.url,s.async,s.username,s.password);
}else{
xhr.open(type,s.url,s.async);
}
try{
if(s.data){
xhr.setRequestHeader("Content-Type",s.contentType);
}
if(s.ifModified){
xhr.setRequestHeader("If-Modified-Since",_3e0.lastModified[s.url]||"Thu, 01 Jan 1970 00:00:00 GMT");
}
xhr.setRequestHeader("X-Requested-With","XMLHttpRequest");
xhr.setRequestHeader("Accept",s.dataType&&s.accepts[s.dataType]?s.accepts[s.dataType]+", */*":s.accepts._default);
}
catch(e){
}
if(s.beforeSend&&s.beforeSend(xhr,s)===false){
s.global&&_3e0.active--;
xhr.abort();
return false;
}
if(s.global){
_3e0.event.trigger("ajaxSend",[xhr,s]);
}
var _5e6=function(_5e7){
if(!_5e4&&xhr&&(xhr.readyState==4||_5e7=="timeout")){
_5e4=true;
if(ival){
clearInterval(ival);
ival=null;
}
_5da=_5e7=="timeout"&&"timeout"||!_3e0.httpSuccess(xhr)&&"error"||s.ifModified&&_3e0.httpNotModified(xhr,s.url)&&"notmodified"||"success";
if(_5da=="success"){
try{
data=_3e0.httpData(xhr,s.dataType,s.dataFilter);
}
catch(e){
_5da="parsererror";
}
}
if(_5da=="success"){
var _5e9;
try{
_5e9=xhr.getResponseHeader("Last-Modified");
}
catch(e){
}
if(s.ifModified&&_5e9){
_3e0.lastModified[s.url]=_5e9;
}
if(!_5d8){
success();
}
}else{
_3e0.handleError(s,xhr,_5da);
}
complete();
if(s.async){
xhr=null;
}
}
};
if(s.async){
var ival=setInterval(_5e6,13);
if(s.timeout>0){
setTimeout(function(){
if(xhr){
xhr.abort();
if(!_5e4){
_5e6("timeout");
}
}
},s.timeout);
}
}
try{
xhr.send(s.data);
}
catch(e){
_3e0.handleError(s,xhr,null,e);
}
if(!s.async){
_5e6();
}
function success(){
if(s.success){
s.success(data,_5da);
}
if(s.global){
_3e0.event.trigger("ajaxSuccess",[xhr,s]);
}
}
function complete(){
if(s.complete){
s.complete(xhr,_5da);
}
if(s.global){
_3e0.event.trigger("ajaxComplete",[xhr,s]);
}
if(s.global&&!--_3e0.active){
_3e0.event.trigger("ajaxStop");
}
}
return xhr;
},handleError:function(s,xhr,_5ec,e){
if(s.error){
s.error(xhr,_5ec,e);
}
if(s.global){
_3e0.event.trigger("ajaxError",[xhr,s,e]);
}
},active:0,httpSuccess:function(xhr){
try{
return !xhr.status&&location.protocol=="file:"||(xhr.status>=200&&xhr.status<300)||xhr.status==304||xhr.status==1223||_3e0.browser.safari&&xhr.status==_3e5;
}
catch(e){
}
return false;
},httpNotModified:function(xhr,url){
try{
var _5f1=xhr.getResponseHeader("Last-Modified");
return xhr.status==304||_5f1==_3e0.lastModified[url]||_3e0.browser.safari&&xhr.status==_3e5;
}
catch(e){
}
return false;
},httpData:function(xhr,type,_5f4){
var ct=xhr.getResponseHeader("content-type"),xml=type=="xml"||!type&&ct&&ct.indexOf("xml")>=0,data=xml?xhr.responseXML:xhr.responseText;
if(xml&&data.documentElement.tagName=="parsererror"){
throw "parsererror";
}
if(_5f4){
data=_5f4(data,type);
}
if(type=="script"){
_3e0.globalEval(data);
}
if(type=="json"){
data=eval("("+data+")");
}
return data;
},param:function(a){
var s=[];
if(a.constructor==Array||a.jquery){
_3e0.each(a,function(){
s.push(encodeURIComponent(this.name)+"="+encodeURIComponent(this.value));
});
}else{
for(var j in a){
if(a[j]&&a[j].constructor==Array){
_3e0.each(a[j],function(){
s.push(encodeURIComponent(j)+"="+encodeURIComponent(this));
});
}else{
s.push(encodeURIComponent(j)+"="+encodeURIComponent(_3e0.isFunction(a[j])?a[j]():a[j]));
}
}
}
return s.join("&").replace(/%20/g,"+");
}});
_3e0.fn.extend({show:function(_5fb,_5fc){
return _5fb?this.animate({height:"show",width:"show",opacity:"show"},_5fb,_5fc):this.filter(":hidden").each(function(){
this.style.display=this.oldblock||"";
if(_3e0.css(this,"display")=="none"){
var elem=_3e0("<"+this.tagName+" />").appendTo("body");
this.style.display=elem.css("display");
if(this.style.display=="none"){
this.style.display="block";
}
elem.remove();
}
}).end();
},hide:function(_5fe,_5ff){
return _5fe?this.animate({height:"hide",width:"hide",opacity:"hide"},_5fe,_5ff):this.filter(":visible").each(function(){
this.oldblock=this.oldblock||_3e0.css(this,"display");
this.style.display="none";
}).end();
},_toggle:_3e0.fn.toggle,toggle:function(fn,fn2){
return _3e0.isFunction(fn)&&_3e0.isFunction(fn2)?this._toggle.apply(this,arguments):fn?this.animate({height:"toggle",width:"toggle",opacity:"toggle"},fn,fn2):this.each(function(){
_3e0(this)[_3e0(this).is(":hidden")?"show":"hide"]();
});
},slideDown:function(_602,_603){
return this.animate({height:"show"},_602,_603);
},slideUp:function(_604,_605){
return this.animate({height:"hide"},_604,_605);
},slideToggle:function(_606,_607){
return this.animate({height:"toggle"},_606,_607);
},fadeIn:function(_608,_609){
return this.animate({opacity:"show"},_608,_609);
},fadeOut:function(_60a,_60b){
return this.animate({opacity:"hide"},_60a,_60b);
},fadeTo:function(_60c,to,_60e){
return this.animate({opacity:to},_60c,_60e);
},animate:function(prop,_610,_611,_612){
var _613=_3e0.speed(_610,_611,_612);
return this[_613.queue===false?"each":"queue"](function(){
if(this.nodeType!=1){
return false;
}
var opt=_3e0.extend({},_613),p,_616=_3e0(this).is(":hidden"),self=this;
for(p in prop){
if(prop[p]=="hide"&&_616||prop[p]=="show"&&!_616){
return opt.complete.call(this);
}
if(p=="height"||p=="width"){
opt.display=_3e0.css(this,"display");
opt.overflow=this.style.overflow;
}
}
if(opt.overflow!=null){
this.style.overflow="hidden";
}
opt.curAnim=_3e0.extend({},prop);
_3e0.each(prop,function(name,val){
var e=new _3e0.fx(self,opt,name);
if(/toggle|show|hide/.test(val)){
e[val=="toggle"?_616?"show":"hide":val](prop);
}else{
var _61b=val.toString().match(/^([+-]=)?([\d+-.]+)(.*)$/),_61c=e.cur(true)||0;
if(_61b){
var end=parseFloat(_61b[2]),unit=_61b[3]||"px";
if(unit!="px"){
self.style[name]=(end||1)+unit;
_61c=((end||1)/e.cur(true))*_61c;
self.style[name]=_61c+unit;
}
if(_61b[1]){
end=((_61b[1]=="-="?-1:1)*end)+_61c;
}
e.custom(_61c,end,unit);
}else{
e.custom(_61c,val,"");
}
}
});
return true;
});
},queue:function(type,fn){
if(_3e0.isFunction(type)||(type&&type.constructor==Array)){
fn=type;
type="fx";
}
if(!type||(typeof type=="string"&&!fn)){
return queue(this[0],type);
}
return this.each(function(){
if(fn.constructor==Array){
_621(this,type,fn);
}else{
_621(this,type).push(fn);
if(_621(this,type).length==1){
fn.call(this);
}
}
});
},stop:function(_622,_623){
var _624=_3e0.timers;
if(_622){
this.queue([]);
}
this.each(function(){
for(var i=_624.length-1;i>=0;i--){
if(_624[i].elem==this){
if(_623){
_624[i](true);
}
_624.splice(i,1);
}
}
});
if(!_623){
this.dequeue();
}
return this;
}});
var _621=function(elem,type,_628){
if(elem){
type=type||"fx";
var q=_3e0.data(elem,type+"queue");
if(!q||_628){
q=_3e0.data(elem,type+"queue",_3e0.makeArray(_628));
}
}
return q;
};
_3e0.fn.dequeue=function(type){
type=type||"fx";
return this.each(function(){
var q=_621(this,type);
q.shift();
if(q.length){
q[0].call(this);
}
});
};
_3e0.extend({speed:function(_62c,_62d,fn){
var opt=_62c&&_62c.constructor==Object?_62c:{complete:fn||!fn&&_62d||_3e0.isFunction(_62c)&&_62c,duration:_62c,easing:fn&&_62d||_62d&&_62d.constructor!=Function&&_62d};
opt.duration=(opt.duration&&opt.duration.constructor==Number?opt.duration:_3e0.fx.speeds[opt.duration])||_3e0.fx.speeds.def;
opt.old=opt.complete;
opt.complete=function(){
if(opt.queue!==false){
_3e0(this).dequeue();
}
if(_3e0.isFunction(opt.old)){
opt.old.call(this);
}
};
return opt;
},easing:{linear:function(p,n,_632,diff){
return _632+diff*p;
},swing:function(p,n,_636,diff){
return ((-Math.cos(p*Math.PI)/2)+0.5)*diff+_636;
}},timers:[],timerId:null,fx:function(elem,_639,prop){
this.options=_639;
this.elem=elem;
this.prop=prop;
if(!_639.orig){
_639.orig={};
}
}});
_3e0.fx.prototype={update:function(){
if(this.options.step){
this.options.step.call(this.elem,this.now,this);
}
(_3e0.fx.step[this.prop]||_3e0.fx.step._default)(this);
if(this.prop=="height"||this.prop=="width"){
this.elem.style.display="block";
}
},cur:function(_63b){
if(this.elem[this.prop]!=null&&this.elem.style[this.prop]==null){
return this.elem[this.prop];
}
var r=parseFloat(_3e0.css(this.elem,this.prop,_63b));
return r&&r>-10000?r:parseFloat(_3e0.curCSS(this.elem,this.prop))||0;
},custom:function(from,to,unit){
this.startTime=now();
this.start=from;
this.end=to;
this.unit=unit||this.unit||"px";
this.now=this.start;
this.pos=this.state=0;
this.update();
var self=this;
function t(_641){
return self.step(_641);
}
t.elem=this.elem;
_3e0.timers.push(t);
if(_3e0.timerId==null){
_3e0.timerId=setInterval(function(){
var _642=_3e0.timers;
for(var i=0;i<_642.length;i++){
if(!_642[i]()){
_642.splice(i--,1);
}
}
if(!_642.length){
clearInterval(_3e0.timerId);
_3e0.timerId=null;
}
},13);
}
},show:function(){
this.options.orig[this.prop]=_3e0.attr(this.elem.style,this.prop);
this.options.show=true;
this.custom(0,this.cur());
if(this.prop=="width"||this.prop=="height"){
this.elem.style[this.prop]="1px";
}
_3e0(this.elem).show();
},hide:function(){
this.options.orig[this.prop]=_3e0.attr(this.elem.style,this.prop);
this.options.hide=true;
this.custom(this.cur(),0);
},step:function(_644){
var t=now();
if(_644||t>this.options.duration+this.startTime){
this.now=this.end;
this.pos=this.state=1;
this.update();
this.options.curAnim[this.prop]=true;
var done=true;
for(var i in this.options.curAnim){
if(this.options.curAnim[i]!==true){
done=false;
}
}
if(done){
if(this.options.display!=null){
this.elem.style.overflow=this.options.overflow;
this.elem.style.display=this.options.display;
if(_3e0.css(this.elem,"display")=="none"){
this.elem.style.display="block";
}
}
if(this.options.hide){
this.elem.style.display="none";
}
if(this.options.hide||this.options.show){
for(var p in this.options.curAnim){
_3e0.attr(this.elem.style,p,this.options.orig[p]);
}
}
}
if(done){
this.options.complete.call(this.elem);
}
return false;
}else{
var n=t-this.startTime;
this.state=n/this.options.duration;
this.pos=_3e0.easing[this.options.easing||(_3e0.easing.swing?"swing":"linear")](this.state,n,0,1,this.options.duration);
this.now=this.start+((this.end-this.start)*this.pos);
this.update();
}
return true;
}};
_3e0.extend(_3e0.fx,{speeds:{slow:600,fast:200,def:400},step:{scrollLeft:function(fx){
fx.elem.scrollLeft=fx.now;
},scrollTop:function(fx){
fx.elem.scrollTop=fx.now;
},opacity:function(fx){
_3e0.attr(fx.elem.style,"opacity",fx.now);
},_default:function(fx){
fx.elem.style[fx.prop]=fx.now+fx.unit;
}}});
_3e0.fn.offset=function(){
var left=0,top=0,elem=this[0],_651;
if(elem){
with(_3e0.browser){
var _652=elem.parentNode,_653=elem,_654=elem.offsetParent,doc=elem.ownerDocument,_656=safari&&parseInt(version)<522&&!/adobeair/i.test(_4bd),css=_3e0.curCSS,_658=css(elem,"position")=="fixed";
if(elem.getBoundingClientRect){
var box=elem.getBoundingClientRect();
add(box.left+Math.max(doc.documentElement.scrollLeft,doc.body.scrollLeft),box.top+Math.max(doc.documentElement.scrollTop,doc.body.scrollTop));
add(-doc.documentElement.clientLeft,-doc.documentElement.clientTop);
}else{
add(elem.offsetLeft,elem.offsetTop);
while(_654){
add(_654.offsetLeft,_654.offsetTop);
if(mozilla&&!/^t(able|d|h)$/i.test(_654.tagName)||safari&&!_656){
border(_654);
}
if(!_658&&css(_654,"position")=="fixed"){
_658=true;
}
_653=/^body$/i.test(_654.tagName)?_653:_654;
_654=_654.offsetParent;
}
while(_652&&_652.tagName&&!/^body|html$/i.test(_652.tagName)){
if(!/^inline|table.*$/i.test(css(_652,"display"))){
add(-_652.scrollLeft,-_652.scrollTop);
}
if(mozilla&&css(_652,"overflow")!="visible"){
border(_652);
}
_652=_652.parentNode;
}
if((_656&&(_658||css(_653,"position")=="absolute"))||(mozilla&&css(_653,"position")!="absolute")){
add(-doc.body.offsetLeft,-doc.body.offsetTop);
}
if(_658){
add(Math.max(doc.documentElement.scrollLeft,doc.body.scrollLeft),Math.max(doc.documentElement.scrollTop,doc.body.scrollTop));
}
}
_651={top:top,left:left};
}
}
function border(elem){
add(_3e0.curCSS(elem,"borderLeftWidth",true),_3e0.curCSS(elem,"borderTopWidth",true));
}
function add(l,t){
left+=parseInt(l,10)||0;
top+=parseInt(t,10)||0;
}
return _651;
};
_3e0.fn.extend({position:function(){
var left=0,top=0,_65f;
if(this[0]){
var _660=this.offsetParent(),_661=this.offset(),_662=/^body|html$/i.test(_660[0].tagName)?{top:0,left:0}:_660.offset();
_661.top-=num(this,"marginTop");
_661.left-=num(this,"marginLeft");
_662.top+=num(_660,"borderTopWidth");
_662.left+=num(_660,"borderLeftWidth");
_65f={top:_661.top-_662.top,left:_661.left-_662.left};
}
return _65f;
},offsetParent:function(){
var _663=this[0].offsetParent;
while(_663&&(!/^body|html$/i.test(_663.tagName)&&_3e0.css(_663,"position")=="static")){
_663=_663.offsetParent;
}
return _3e0(_663);
}});
_3e0.each(["Left","Top"],function(i,name){
var _666="scroll"+name;
_3e0.fn[_666]=function(val){
if(!this[0]){
return;
}
return val!=_3e5?this.each(function(){
this==window||this==document?window.scrollTo(!i?val:_3e0(window).scrollLeft(),i?val:_3e0(window).scrollTop()):this[_666]=val;
}):this[0]==window||this[0]==document?self[i?"pageYOffset":"pageXOffset"]||_3e0.boxModel&&document.documentElement[_666]||document.body[_666]:this[0][_666];
};
});
_3e0.each(["Height","Width"],function(i,name){
var tl=i?"Left":"Top",br=i?"Right":"Bottom";
_3e0.fn["inner"+name]=function(){
return this[name.toLowerCase()]()+num(this,"padding"+tl)+num(this,"padding"+br);
};
_3e0.fn["outer"+name]=function(_66c){
return this["inner"+name]()+num(this,"border"+tl+"Width")+num(this,"border"+br+"Width")+(_66c?num(this,"margin"+tl)+num(this,"margin"+br):0);
};
});
})();
jQuery.noConflict();
(function($){
(function(){
if(typeof (Quill)=="undefined"){
Quill={};
}
Quill.toolbar={};
Quill.toolbar.defaultValues={"englishFonts":["Arial","Courier New","Georgia","Times New Roman","Verdana","Trebuchet MS","Lucida Sans"],"LangFonts":{"Bengali":"Vrinda","Gujarati":"Shruti","Hindi":"Mangal","Kannada":"Tunga","Malayalam":"Kartika","Marathi":"Mangal","Tamil":"Latha","Telugu":"Gautami","Punjabi":"Raavi","Nepali":"Mangal"},"fontSize_width":40,"font_width":60,"fontSizeList":[14,16,18,24,32,48]};
Quill.toolbar.ListBox=function(ele,_66f,_670,_671,_672){
this.init_=function(ele,_674,_675,_676){
this.element_=$(ele);
this.items=_674;
for(var j=0;_671&&j<this.items.length;j++){
var _678=$("<option value=\""+this.items[j]+"\" >"+this.items[j]+"</option>",_675);
$(this.element_).append(_678);
}
$(this.element_).change(_676);
};
this.set_value=function(val){
for(var i=0;i<this.items.length;++i){
if(this.items[i]==val){
this.element_[0].selectedIndex=i;
return;
}
}
this.element_[0].selectedIndex=-1;
};
this.init_(ele,_66f,_670,_672);
};
Quill.toolbar.panel=function(id,_67c,doc,_67e){
if(typeof (_67c)=="undefined"||typeof (_67c)==null||!_67c){
this.update_panel=function(){
};
return;
}
var that=this;
this.doc=doc;
this.editor=_67e;
this.id=id;
this.ele=doc.getElementById(_67c);
var _680=selected_languages;
var _681=false;
if(!$(this.ele).attr("quill-langs")){
_681=true;
}
$(this.ele).attr("quill-langs",true);
this.font_list_box=new Quill.toolbar.ListBox(this.ele,_680,this.doc,_681,function(){
var lang=that.font_list_box.element_.val();
that.editor.change_lang(lang);
});
this.update_panel=function(){
var a=this.editor.get_selection_item_attributes();
if(a==null){
a=this.editor.get_new_item_attributes();
}
if(this.font_list_box){
if(a.lang==null||a.font_name==null){
this.font_list_box.set_value("");
}else{
if(a.lang=="english"&&false){
this.font_list_box.set_value(a.font_name);
}else{
this.font_list_box.set_value(a.lang.charAt(0).toUpperCase()+a.lang.substr(1).toLowerCase());
}
}
}
};
};
if(typeof (Quill)=="undefined"){
Quill={};
}
Quill.objects={};
Quill.init=function(id,_685,_686,lang){
if(Quill.getObject(id)){
if(typeof (console)!="undefined"&&typeof (console.log)!="undefined"){
console.log("Element with id="+id+" is already initialized");
}
return;
}
useVKB=false;
if(typeof (lang)=="undefined"||lang==null){
var lang=Quill.lib.isSet(Quill.Config,"client","defaultLanguage","hindi");
}
if($("#"+_685)[0]&&$("#"+_685+" option").length!=0){
lang=$("#"+_685+" option:selected").val();
}
var conf={};
var ta=document.getElementById(id);
var _68a=$(ta).outerWidth();
var _68b=$(ta).outerHeight();
var _68c=$(ta).offset();
var top=_68c.top;
var left=_68c.left;
var _68f=$(ta).attr("type")!=="text";
var _690=$(ta).attr("tabindex");
$(ta).removeAttr("tabindex");
conf["is_textArea"]=_68f;
conf["useVKB"]=useVKB;
var uid="Quill"+id;
var _692=$("<div id="+uid+"_container>  </div>",ta.ownerDocument);
$(_692).css({"width":_68a+"px","height":_68b+"px","border":"1px solid #7f9db9","background-color":"white"});
if($.browser.msie||Quill.lib.isMobile){
var _693=$("<div id="+uid+">  </div>",ta.ownerDocument);
}else{
var _693=$("<iframe name='"+uid+"' id='"+uid+"' frameborder=0 maringwidth=0 maringheight=0 scrolling='auto'>"+"</iframe>",ta.ownerDocument);
}
_693.css({"width":_68a-5+"px","height":_68b+"px","position":"relative"});
if(_68f){
_693.css({"overflow":"auto"});
}
if(Quill.lib.isAndroid||Quill.lib.isiOS){
_693.css({"overflow":"scroll","-webkit-overflow-scrolling":"touch"});
}
if(!_68f){
conf["showFormatPanel"]=false;
}
$(_692).append(_693);
var vari=0;
if($.browser.mozilla){
vari=2;
}
var _695;
var _696=null;
if(_68f){
var mc=$("<div></div>",ta.ownerDocument);
mc.css("width",_68a+2);
mc.append(_692);
var lang=lang.charAt(0).toUpperCase()+lang.substr(1).toLowerCase();
_696=$("<a id=\""+uid+"_Quillpad_link\" href=\"http://quillpad.in\" style=\"text-decoration:none; float:right;font-size:14px !important; display:none;\" target=\"_blank\">"+lang+" Typing by Quillpad</a>");
var div=$("<div style=\" font-size:14px !important; font-family:'museo-sans', ARIAL UNICODE MS,mangal,raghu8\">&nbsp;</div>");
div.append(_696);
$(mc).append(div);
$(ta).after(mc);
_695=$("<div class=\"QuillKeyboardContainer\"></div>");
$(mc).after(_695);
}else{
$(ta).after(_692);
_695=$("<div class=\"QuillKeyboardContainer\"></div>");
$(_692).after(_695);
}
$(ta).css({"display":"none"});
var h=$(_692).height()-vari;
var ifr=ta.ownerDocument.getElementById(uid);
$(ifr).css({"height":h+"px"});
var win;
if($.browser.msie||Quill.lib.isMobile){
win=window;
}else{
win=_693[0].contentWindow;
}
win.setTimeout(function(){
var doc=win.document;
if($.browser.msie||Quill.lib.isMobile){
var body=_693;
}else{
var body=$("body",doc);
}
var _69e;
if(_68f){
_69e="pre-wrap";
body.css({"margin":"0px","padding-left":"5px"});
}else{
_69e="nowrap";
body.css({"margin":"0px","overflow-x":"hidden","overflow-y":"hidden"});
}
var left=-9999;
if(Quill.lib.isAndroid){
left=0;
}
var _6a0="";
if(_690){
_6a0="tabindex=\""+_690+"\"";
}
body.html("<div style='width:99%; height:99%; outline-style:none;"+"white-space:"+_69e+";' id="+uid+"_div></div><textarea id=inputField_"+uid+" "+_6a0+" style='position:absolute; top:0px; left:"+left+"px; height:10px; width:10px; border:1px;'></textarea>",doc);
var ed=new Quill.do_init(uid,lang,null,left,top,ta.ownerDocument,conf,_685,_686);
var ta1=win.document.createElement("TEXTAREA");
ta1.setAttribute("id","paste");
ta1.style.display="none";
ta1.style.position="absolute";
ta1.style.overflow="hidden";
ta1.style.top="1px";
ta1.style.left="30px";
ta1.style.height="1px";
ta1.style.width="1px";
ta1.style.backgroundColor="#ffffff";
ta1.style.border="0px #ffffff";
body[0].appendChild(ta1);
if(!_68f){
ed.editor_.SPACE_CHAR="\xa0";
}
ed.vkb_container=_695;
ed.vkeyBoard_=new KeyboardManager(id);
ed.isVkBoradVisible=false;
ed.useKB=conf["useVKB"];
ed.quillpad_link=_696;
Quill.objects[uid]=ed;
var _6a3=Quill.lib.isSet(Quill.Config,"client","showKeyboard",false);
if(_6a3&&conf["useVKB"]){
var _6a4=$("<div id=\""+id+"_vkbLoading\"><div style=\"margin-top: 100px;\"><h3>Loading...</h3></div></div>");
var _6a5=$("<div id=\""+id+"_keyboardArea\"></div>");
$(ed.vkb_container).append(_6a4).append(_6a5);
var attr=ed.editor_.get_new_item_attributes();
ed.vkeyBoard_.show(attr.lang);
ed.isVkBoradVisible=true;
}
Quill.update_ui_state(uid);
},0);
};
Quill.update_ui_state=function(id){
var _6a8=Quill.objects[id].toolbar_;
if(_6a8){
_6a8.update_panel();
}
if(Quill.objects[id].quillpad_link){
var ed=Quill.objects[id].editor_;
var a=ed.get_selection_item_attributes();
if(a==null){
a=ed.get_new_item_attributes();
}
if(a.lang!=null){
var lang=a.lang;
lang=lang.charAt(0).toUpperCase()+lang.substr(1).toLowerCase();
$(Quill.objects[id].quillpad_link).text("");
}
}
};
Quill.keycode_name=function(_6ac){
var name=null;
if(_6ac==37){
name="left";
}else{
if(_6ac==39){
name="right";
}else{
if(_6ac==38){
name="up";
}else{
if(_6ac==40){
name="down";
}else{
if(_6ac==36){
name="home";
}else{
if(_6ac==35){
name="end";
}else{
if(_6ac==33){
name="pageup";
}else{
if(_6ac==34){
name="pagedown";
}else{
if(_6ac==46){
name="delete";
}else{
if(_6ac==8){
name="backspace";
}else{
if(_6ac==13){
name="enter";
}else{
if(_6ac==9){
name="tab";
}else{
if(_6ac==119){
name="toggle";
}
}
}
}
}
}
}
}
}
}
}
}
}
return name;
};
Quill.handle_key_code=function(id,_6af,_6b0,_6b1,_6b2,_6b3){
var _6b4=Quill.objects[id].editor_;
var _6b5=Quill.objects[id].is_textarea_;
if(_6b1||_6b2||_6b3){
return false;
}
var name=Quill.keycode_name(_6af);
if(name==null){
return false;
}
switch(name){
case "left":
_6b4.move_left(_6b0);
break;
case "right":
_6b4.move_right(_6b0);
break;
case "home":
_6b4.move_home(_6b0);
break;
case "end":
_6b4.move_end(_6b0);
break;
case "up":
_6b4.move_up(_6b0);
break;
case "down":
_6b4.move_down(_6b0);
break;
case "pageup":
for(var i=0;i<10;++i){
_6b4.move_up(_6b0);
}
break;
case "pagedown":
for(var i=0;i<10;++i){
_6b4.move_down(_6b0);
}
break;
case "delete":
_6b4.key_delete();
break;
case "backspace":
_6b4.key_backspace();
break;
case "enter":
if(_6b5){
_6b4.key_enter();
}
break;
case "tab":
if(_6b4.caret_on_word_){
_6b4.key_tab();
}else{
return false;
}
break;
case "toggle":
_6b4.toggle_lang();
Quill.update_ui_state(id);
break;
default:
Quill.lib.assert(false);
}
return true;
};
Quill.handle_key_char=function(id,_6b9,_6ba,_6bb,_6bc,_6bd){
var _6be=Quill.objects[id].editor_;
var _6bf={"z":_6be.undo,"y":_6be.redo,"v":_6be.paste,"x":_6be.internal_cut,"c":_6be.internal_copy,"a":_6be.select_all};
var _6c0=function(ch){
var _6c2=["1","2","3","4","5","6","7","8","9","0","!","@","#","$","%","^","&","*","(",")","`","=","[","]",";","'","\\","/","~","_","+","{","}",":","\"","<",">"];
return ($.inArray(ch,_6c2)>-1);
};
var ch=String.fromCharCode(_6b9);
var lch=ch.toLowerCase();
var _6c5=_6bf[lch];
if((_6bb||_6bd)&&(!_6bc)&&(_6c5)){
_6c5.call(_6be);
if((lch=="z")||(lch=="y")||(lch=="a")){
return true;
}
}
if(_6bb||_6bc||_6bd){
return false;
}
if(_6be.max_char_count>0&&_6be.max_char_count-_6be.char_count<=0){
return true;
}
if(_6b9==32){
_6be.key_space(ch);
}else{
if((_6b9>=65)&&(_6b9<65+26)){
_6be.key_xlit_char(ch);
}else{
if((_6b9>=97)&&(_6b9<97+26)){
_6be.key_xlit_char(ch);
}else{
if(_6be.inscript_mode&&_6c0(ch)){
_6be.key_xlit_char(ch);
}else{
_6be.key_simple_char(ch);
}
}
}
}
return true;
};
Quill.do_init=function(id,lang,_6c8,_6c9,_6ca,_6cb,conf,_6cd,_6ce){
popup_doc=_6cb;
this.id_=id;
this.is_textarea_=conf.is_textArea;
var that=this;
this.on_popup_choice=function(){
that.editor_.grab_focus();
that.editor_.set_has_focus(true);
that.editor_.move_right();
$(that.editor_.input_listener).focus();
};
this.editor_popup_=new QuillPopup(popup_doc,this.on_popup_choice);
this.editor_popup_.set_offset(0,0);
var ifr=_6cb.getElementById(this.id_);
var te=$(ifr).offset();
if($.browser.msie||Quill.lib.isMobile){
var doc=document;
}else{
var doc=ifr.contentDocument?ifr.contentDocument:ifr.contentWindow.document;
}
this.editor_root_=doc.getElementById(this.id_+"_div");
var _6d3=window.document.getElementById("inputField_"+this.id_);
this.editor_=new QuillEditor(doc,this.editor_root_,this.editor_popup_,lang,($.browser.msie||Quill.lib.isMobile)?ifr:ifr.contentWindow,_6ce,this.is_textarea_,_6d3);
this.editor_.find_xy=function(){
var ifr=_6cb.getElementById(that.id_);
var te=$(ifr).offset();
return te;
};
this.editor_.set_textarea_update_callback(function(){
$("#"+that.id_.substring(5),_6cb).attr("value",that.editor_.get_language_text());
});
this.dragging_=false;
var that=this;
this.toolbar_=new Quill.toolbar.panel(this.id_,_6cd,_6cb,this.editor_);
var win=($.browser.msie||Quill.lib.isMobile)?window:ifr.contentWindow;
this.cursor_timer=win.setInterval(function(){
if(typeof (Quill)!="undefined"){
var ed=Quill.objects[that.id_].editor_;
if(ed){
ed.toggle_caret_blink();
}
}
},500);
this.focus_listener=this.editor_root_;
var _6d8=navigator.userAgent.toLowerCase();
var _6d9=_6d8.match(/(iphone|ipod|ipad)/);
if(!_6d9){
window.onfocus=function(e){
};
}
document.getElementById(this.id_).onfocus=function(e){
that.editor_.grab_focus();
that.editor_.set_has_focus(true);
};
$(ifr.contentWindow).resize(function(e){
that.editor_.update_on_resize();
});
$(this.focus_listener).change(function(e){
});
$(this.editor_root_).mousedown(function(e){
that.editor_.grab_focus();
if(that.dragging_){
return;
}
that.dragging_=true;
var then=that;
$(that.editor_root_).mousemove(function(e){
then.editor_.move_caret_to_xy(e.pageX,e.pageY,true);
Quill.update_ui_state(then.id_);
});
that.editor_.move_caret_to_xy(e.pageX,e.pageY,false);
that.editor_.set_has_focus(true);
$(_6d3).focus();
});
$(that.editor_root_).mouseup(function(e){
that.dragging_=false;
$(that.editor_root_).unbind("mousemove");
});
$(_6d3).focus(function(e){
that.editor_.set_has_focus(true);
});
$(this.focus_listener).focus(function(e){
});
$(_6d3).keypress(function(e){
var _6e5=false;
if(e.which>=32){
if((!(doc.parentWindow&&doc.parentWindow.event))||(!e.ctrlKey)){
_6e5=Quill.handle_key_char(that.id_,e.which,e.shiftKey,e.ctrlKey,e.altKey,e.metaKey);
}
}else{
if((!(doc.parentWindow&&doc.parentWindow.event))&&((e.which==0)||(e.which==8)||(e.which==13))){
_6e5=Quill.handle_key_code(that.id_,e.keyCode,e.shiftKey,e.ctrlKey,e.altKey,e.metaKey);
}
}
if(_6e5){
e.preventDefault();
Quill.update_ui_state(that.id_);
}
return true;
});
$(_6d3).keydown(function(e){
var _6e7;
if($.browser.safari){
if(e.target!=_6d3){
return;
}
}else{
if(!(doc.parentWindow&&doc.parentWindow.event)){
return;
}
}
_6e7=Quill.handle_key_code(that.id_,e.keyCode,e.shiftKey,e.ctrlKey,e.altKey,e.metaKey);
if((!_6e7)&&e.ctrlKey&&(e.keyCode>=32)){
_6e7=Quill.handle_key_char(that.id_,e.keyCode,e.shiftKey,e.ctrlKey,e.altKey,e.metaKey);
}
if(_6e7){
e.preventDefault();
Quill.update_ui_state(that.id_);
}
return true;
});
$(_6d3).blur(function(e){
that.editor_popup_.hide();
that.editor_.set_has_focus(false);
});
$(this.editor_.window_).scroll(function(e){
that.editor_popup_.hide();
});
if($.browser.msie){
$(this.editor_root_).bind("selectstart",function(e){
var src=e.target.id;
if(src!=="paste"){
e.preventDefault();
}
});
}else{
$(this.editor_root_).mousedown(function(e){
e.preventDefault();
});
}
};
Quill.langMap={"bengali":false,"gujarati":false,"hindi":false,"kannada":false,"malayalam":false,"marathi":false,"tamil":false,"telugu":false,"punjabi":false,"nepali":false};
Quill.hasExtraMap=false;
Quill.pendingCallbacks=[];
Quill.onLangMapLoad=function(_6ed,lang){
Quill.pendingCallbacks.push({lang:lang,panelID:_6ed});
};
Quill.clearPendingCallbacks=function(){
for(var i=0;i<Quill.pendingCallbacks.length;i++){
var req=Quill.pendingCallbacks[i];
if(Quill.langMap[req["lang"]]&&Quill.hasExtraMap){
var _6f1=Quill.getObject(req["panelID"]);
if(_6f1){
_6f1.vkeyBoard_.doIt(req["lang"]);
Quill.pendingCallbacks.splice(i,1);
i--;
}
}
}
};
mapLoaded=function(lang){
Quill.langMap[lang]=true;
Quill.clearPendingCallbacks();
};
extraMapLoaded=function(){
Quill.hasExtraMap=true;
Quill.clearPendingCallbacks();
};
Quill.getObject=function(key){
if(Quill.objects.hasOwnProperty("Quill"+key)){
return this.objects["Quill"+key];
}
};
Quill.showkeyBoard=function(key){
var _6f5=Quill.getObject(key);
if(_6f5&&_6f5.useKB&&_6f5.isVkBoradVisible!=true){
var _6f6=$("<div id=\""+key+"_vkbLoading\"><div style=\"margin-top: 100px;\"><h3>Loading...</h3></div></div>");
var _6f7=$("<div id=\""+key+"_keyboardArea\"></div>");
$(_6f5.vkb_container).append(_6f6).append(_6f7);
var attr=_6f5.editor_.get_new_item_attributes();
_6f5.vkeyBoard_.show(attr.lang);
_6f5.isVkBoradVisible=true;
}
};
Quill.hideKeyBoard=function(key){
var _6fa=Quill.getObject(key);
if(_6fa){
$(_6fa.vkb_container).children().remove();
_6fa.isVkBoradVisible=false;
}
};
Quill.show=function(key,show){
if(Quill.getObject(key)){
if(show){
$("#"+key).hide();
$("#Quill"+key+"_container").show();
}else{
$("#"+key).show();
$("#Quill"+key+"_container").hide();
}
}else{
setTimeout(function(){
Quill.show(key,show);
},200);
}
};
Quill.getLanguageText=function(key){
var _6fe=Quill.getObject(key);
if(_6fe){
return _6fe.editor_.get_language_text();
}
return null;
};
Quill.setLanguage=function(key,lang){
var _701=Quill.getObject(key);
if(_701){
_701.editor_.change_lang(lang);
}else{
setTimeout(function(){
Quill.setLanguage(key,lang);
},200);
}
};
Quill.showOptionpanel=function(key,val){
var _704=Quill.getObject(key);
if(_704){
_704.editor_.disable_popup(!val);
}else{
setTimeout(function(){
Quill.showOptionpanel(key,val);
},200);
}
};
Quill.setCharLimit=function(_705,key){
var _707=Quill.getObject(key);
if(_707){
_707.editor_.set_char_limit(_705);
}else{
setTimeout(function(){
Quill.setCharLimit(_705,key);
},200);
}
};
Quill.setFocus=function(key){
var _709=Quill.getObject(key);
if(_709){
_709.editor_.grab_focus();
}
};
Quill.clearText=function(key){
var _70b=Quill.getObject(key);
if(_70b){
_70b.editor_.clear_doc();
}else{
setTimeout(function(){
Quill.clearText(limit,key);
},200);
}
};
Quill.getEnglishText=function(key){
var _70d=Quill.getObject(key);
if(_70d){
return _70d.editor_.get_english_text();
}
return null;
};
Quill.getCharsLeft=function(key){
var _70f=Quill.getObject(key);
if(_70f){
return _70f.editor_.max_char_count-_70f.editor_.char_count;
}
return null;
};
Quill.loadText=function(text,key){
var _712=Quill.getObject(key);
if(_712){
_712.editor_.external_paste(text,true);
}else{
setTimeout(function(){
Quill.loadText(text,key);
},200);
}
};
Quill.addChar=function(key,ch){
var _715=Quill.getObject(key);
if(_715){
_715.editor_.grab_focus();
if(ch.charCodeAt(0)>127){
_715.editor_.key_xlit_char(ch);
}else{
if(ch==" "){
_715.editor_.key_space(ch);
}else{
if(ch=="KEY_BACKSPACE"){
_715.editor_.key_backspace();
}else{
if(ch=="KEY_ENTER"){
_715.editor_.key_enter();
}else{
_715.editor_.key_simple_char(ch);
}
}
}
}
}
};
Quill.setInscriptMode=function(key,val){
var _718=Quill.getObject(key);
if(_718){
_718.editor_.inscript_mode=val;
}else{
setTimeout(function(){
Quill.setInscriptMode(key,val);
},200);
}
};
Quill.getInscriptMode=function(key){
var _71a=Quill.getObject(key);
if(_71a){
return _71a.editor_.inscript_mode;
}
};
Quill.setOnTypingCallback=function(key,func){
var _71d=Quill.getObject(key);
if(_71d){
return _71d.editor_.on_started_typing_callback=func;
}else{
setTimeout(function(){
Quill.setOnTypingCallback(key,func);
},200);
}
};
Quill.setPrefillText=function(key,lang,text){
var _721=Quill.getObject(key);
if(_721){
return _721.editor_.set_prefill_text(text,lang);
}else{
setTimeout(function(){
Quill.setPrefillText(key,lang,text);
},200);
}
};
Quill.remove=function(key){
var _723=Quill.getObject(key);
if(_723){
$(_723.vkb_container).remove();
var root=_723.editor_root_;
var _725=$("#inputField_Quill"+key).attr("tabindex");
$(root).parent().parent().parent().remove();
if(_725){
$("#"+key).attr("tabindex",_725);
}
$("#"+key).show();
window.clearInterval(_723.cursor_timer);
delete Quill.objects["Quill"+key];
}
};
Quill.save=function(key){
alert("Function is deprecated");
};
Quill.load=function(data,key){
alert("Function is deprecated");
};
Quill.appendChar=function(s,key){
alert("Function is deprecated");
};
Quill.hidePanels=function(key){
alert("Function is deprecated");
};
Quill.setDimensions=function(key,h,w){
alert("Function is deprecated");
};
Quill.setCallback=function(key,_730){
alert("Function is deprecated");
};
if(typeof (Quill)=="undefined"){
Quill={};
}
Quill.lib={};
Quill.lib.assert=function(cond,msg){
if(!cond){
alert("assertion failed: "+msg);
}
};
Quill.lib.parent_index=function(node){
Quill.lib.assert(node.parentNode,"no parent");
var _734=node.parentNode;
var i=0;
while(i<_734.childNodes.length){
if(_734.childNodes[i]===node){
return i;
}
++i;
}
Quill.lib.assert(false);
};
Quill.lib.unique_id=function(doc,_737){
var id;
do{
id=Math.floor(Math.random()*10000);
}while(document.getElementById(_737+id)!==null);
return id;
};
Quill.lib.node_path_string=function(node){
if(!node.parentNode){
return node.nodeName;
}else{
return Quill.lib.node_path_string(node.parentNode)+"->"+node.nodeName;
}
};
Quill.lib.bind_this=function(obj,func){
return function(){
return func.apply(obj,arguments);
};
};
Quill.lib.font_size=function(lang){
var _73d=Quill.lib.isSet(Quill.Config,"fontSizes",lang,null);
if(_73d!=null){
return _73d[0];
}else{
_73d=Quill.lib.isSet(Quill.Config,"fontSizes","hindi",null);
if(_73d!=null){
return _73d[0];
}
}
if(lang=="bengali"){
return 20;
}
if(lang=="malayalam"){
return 16;
}
return 12;
};
Quill.lib.Logger=function(_73e){
var _73f=document.getElementById(_73e);
var win=_73f.contentWindow;
var doc=win.document;
var body=doc.getElementsByTagName("body")[0];
this.print=function(msg){
var node=doc.createElement("tt");
var text=doc.createTextNode(msg);
node.appendChild(text);
var div=doc.createElement("div");
div.appendChild(node);
body.appendChild(div);
div.scrollIntoView();
};
this.clear=function(){
while(body.lastChild!==null){
body.removeChild(body.lastChild);
}
};
};
Quill.lib.add_script_request=function(url){
var head=document.getElementsByTagName("head")[0];
var _749=Quill.lib.unique_id(document,"scr");
var _74a=document.createElement("script");
_74a.setAttribute("type","text/javascript");
_74a.setAttribute("id","scr"+_749);
_74a.setAttribute("src",url);
head.appendChild(_74a);
return _749;
};
Quill.lib.remove_script_request=function(id){
var head=document.getElementsByTagName("head")[0];
var _74d=document.getElementById("scr"+id);
head.removeChild(_74d);
};
Quill.lib.Cache=new function(){
this.cache={};
this.supported_langs={};
var _74e=["bengali","gujarati","hindi","kannada","malayalam","marathi","tamil","telugu","english","punjabi","nepali"];
for(var i=0;i<_74e.length;i++){
this.cache[_74e[i]]={};
this.supported_langs[_74e[i]]=1;
}
};
Quill.lib.add_to_cache=function(lang,eng,data,c){
if(c.supported_langs[lang]){
c.cache[lang][eng]=data;
}
};
Quill.lib.check_cache=function(lang,eng,c){
var data;
if(c.supported_langs[lang]){
data=c.cache[lang][eng];
}
if(data){
return data;
}
return null;
};
Quill.lib._quill_request_next_id=0;
Quill.lib._quill_requests=new Object();
Quill.lib._quill_callback=function(data,id,_75a){
function work(){
var qr=Quill.lib._quill_requests["qr"+id];
if(qr){
qr.on_response(data,id,_75a);
}
}
setTimeout(work,0);
};
Quill.lib.quill_url=function(lang,_75d,_75e,id){
var _760=Quill.Config.server;
return _760.location+_760.processWord+"?key=PPLMGWGLH74DUW56GATSH6JGJHNPPTYI&lang="+lang+"&inString="+_75d+"&callback="+_75e+"&scid="+id;
};
Quill.lib.consrtuctItransResponse=function(lang,_762){
var _763="";
var len=_762.length;
for(var i=0;i<len;i++){
try{
_763+=Inscript_Map[lang][_762.charAt(i)];
}
catch(e){
_763+=_762.charAt(i);
}
}
return {"twords":[{"optmap":{},"word":true,"options":[_763]}],"itrans":_763,"inString":_762};
};
Quill.lib.QuillRequest=function(lang,_767,_768,_769,_76a){
var _76b=Quill.lib.check_cache(lang,_767,Quill.lib.Cache);
var _76c=false;
var _76d=Quill.lib._quill_request_next_id++;
this.quill_request_id=_76d;
Quill.lib._quill_requests["qr"+_76d]=this;
if(_769){
_76c=true;
Quill.lib._quill_callback(Quill.lib.consrtuctItransResponse(lang,_767),_76d,_76c);
}else{
if(_76b){
_76c=true;
Quill.lib._quill_callback(_76b,_76d,_76c);
}else{
var url=Quill.lib.quill_url(lang,_767,"Quill.lib._quill_callback",_76d,_76c);
var _76f=Quill.lib.add_script_request(url);
if(_76a){
_76a.on_request(_76d);
}
}
}
function cleanup(){
if(!_76c&&_76f){
Quill.lib.remove_script_request(_76f);
}
delete Quill.lib._quill_requests["qr"+_76d];
}
this.on_response=function(data,id,_772){
if(_76a&&!_772){
_76a.on_response(id);
}
cleanup();
var opts=Quill.lib.clone(data.twords[0].options);
if(!_772){
Quill.lib.add_to_cache(lang,_767,data,Quill.lib.Cache);
}
_768(opts,data.itrans,_772);
};
this.cancel=function(){
cleanup();
if(_76a&&!_76c){
_76a.on_response(this.quill_request_id);
}
};
};
Quill.lib.clone=function(arr){
var _775=new Array();
for(var i=0;i<arr.length;i++){
_775.push(arr[i]);
}
return _775;
};
Quill.lib.colorstring_to_rgb=function(_777){
var _778=[];
if(_777.charAt(0)==="#"){
var rgb=_777.slice(1);
for(var i=0;i<rgb.length;i+=2){
var _77b=rgb.slice(i,i+2);
_778.push(Number("0x"+_77b));
}
}else{
if(_777.slice(0,3)==="rgb"){
var _77c=_777.match(/[0-9]+/g);
for(var i=0;i<_77c.length;++i){
_778.push(parseInt(_77c[i],10));
}
}else{
_778=[255,255,255];
}
}
return _778;
};
Quill.lib.blend=function(_77d,_77e,_77f){
var _780=Quill.lib.colorstring_to_rgb(_77d);
var _781=Quill.lib.colorstring_to_rgb(_77e);
var rgb=[];
for(var i=0;i<_780.length;++i){
var col=parseInt(_781[i]*_77f+_780[i]*(1-_77f),10);
rgb.push(col>255?255:col);
}
return "rgb("+rgb[0]+","+rgb[1]+","+rgb[2]+")";
};
Quill.lib.isSet=function(obj,_786,_787,_788){
if(typeof (obj)!="undefined"&&typeof (obj[_786])!="undefined"&&typeof (obj[_786][_787])!="undefined"){
return obj[_786][_787];
}
return _788;
};
function scrollbarWidth(){
var div=$("<div style=\"width:50px;height:50px;overflow:hidden;position:absolute;top:-200px;left:-200px;\"><div style=\"height:100px;\"></div>");
$("body").append(div);
var w1=$("div",div).innerWidth();
div.css("overflow-y","scroll");
var w2=$("div",div).innerWidth();
$(div).remove();
return (w1-w2);
}
Quill.lib.isiOS=(navigator.userAgent.match(/(iPad|iPhone|iPod)/i)?true:false);
Quill.lib.isAndroid=(navigator.platform.indexOf("android")>=0);
Quill.lib.isMobile=Quill.lib.isiOS||Quill.lib.isAndroid;
Quill.lib.isMobile=true;
var _78c=0;
var _78d=0;
var _78e=" ";
var _78e=$.browser.msie?"\xa0":" ";
var _78e="\xa0";
var _78f="\xa0";
SCROLL_BAR_WIDTH=16;
function reset_count(){
_78c=0;
_78d=0;
}
function QRect(x,y,_792,_793){
this.left_=x;
this.top_=y;
this.right_=x+_792;
this.bottom_=y+_793;
this.left=function(){
return this.left_;
};
this.top=function(){
return this.top_;
};
this.right=function(){
return this.right_;
};
this.bottom=function(){
return this.bottom_;
};
this.width=function(){
return this.right_-this.left_;
};
this.height=function(){
return this.bottom_-this.top_;
};
this.contains=function(x,y){
if(x<this.left_){
return false;
}
if(x>this.right_){
return false;
}
if(y<this.top_){
return false;
}
if(y>this.bottom_){
return false;
}
return true;
};
this.equals=function(rect){
if(this.left()!=rect.left()){
return false;
}
if(this.top()!=rect.left()){
return false;
}
if(this.right()!=rect.right()){
return false;
}
if(this.bottom()!=rect.bottom()){
return false;
}
return true;
};
this.above=function(rect){
return (this.bottom()<=rect.top());
};
this.below=function(rect){
return (this.top()>=rect.bottom());
};
this.y_distance=function(y){
if(y<=this.top_){
return this.top_-y;
}
if(y>=this.bottom_){
return y-this.bottom_;
}
return 0;
};
this.x_distance=function(x){
if(x<=this.left_){
return this.left_-x;
}
if(x>=this.right_){
return x-this.right_;
}
return 0;
};
}
var _79b=0;
var _79c={};
function refresh_get_rect(){
++_79b;
_79c={};
}
function QNode(){
this.get_rect_buggy=function(){
var x=0;
var y=0;
var e=this.element();
var w=e.offsetWidth;
var h=e.offsetHeight;
while(e!=null){
x+=e.offsetLeft;
y+=e.offsetTop;
e=e.offsetParent;
}
return new QRect(x,y,w,h);
};
this.last_get_rect_counter=-1;
this.get_scroll=function(win,doc){
var _7a4=0;
if(typeof (win.pageYOffset)=="number"){
_7a4=win.pageYOffset;
}else{
if(doc.body&&(doc.body.scrollLeft||doc.body.scrollTop)){
_7a4=doc.body.scrollTop;
}else{
if(doc.documentElement&&(doc.documentElement.scrollLeft||doc.documentElement.scrollTop)){
_7a4=doc.documentElement.scrollTop;
}
}
}
return _7a4;
};
this.my_offset=function(ele,doc){
var _7a7=self;
if($.browser.mozilla||$.browser.safari){
self=doc.defaultView;
}
var t=$(ele).offset();
if($.browser.mozilla||$.browser.safari){
self=_7a7;
}
return t;
};
this.get_rect=function(){
var _7a9=this.element();
var _7aa=this.my_offset(_7a9,this.ctx_.html_doc);
var left=_7aa.left;
var top=_7aa.top;
var _7ad=_7a9.offsetWidth;
var _7ae=_7a9.offsetHeight;
var _7af=new QRect(left,top,_7ad,_7ae);
this.saved_get_rect=_7af;
this.last_get_rect_counter=_79b;
return _7af;
};
}
function QDocContext(_7b0,root){
this.init_=function(_7b2,root){
this.html_doc=_7b2;
this.root=root;
this.doc=new QDoc(this);
this.xlit_update_callback_=[];
this.textarea_update_callback_=null;
};
this.add_xlit_update_callback=function(cb){
this.xlit_update_callback_.push(cb);
};
this.on_xlit_update=function(){
for(var i=0;i<this.xlit_update_callback_.length;i++){
this.xlit_update_callback_[i]();
}
};
this.new_element=function(tag){
return this.html_doc.createElement(tag);
};
this.new_text_node=function(text){
return this.html_doc.createTextNode(text);
};
this.new_line=function(type,_7b9){
return new QLine(this,type,_7b9);
};
this.new_text_item=function(s){
return new QTextItem(this,s);
};
this.new_xlit_item=function(){
return new QXlitItem(this);
};
this.init_(_7b0,root);
}
function QDoc(ctx){
this.init_=function(ctx){
this.ctx_=ctx;
this.element_=ctx.root;
this.lines_=[];
};
this.element=function(){
return this.element_;
};
this.line_count=function(){
return this.lines_.length;
};
this.line=function(i){
Quill.lib.assert((i>=0)&&(i<this.line_count()));
return this.lines_[i];
};
this.line_index=function(line){
var n=this.line_count();
for(var i=0;i<n;++i){
if(this.lines_[i]===line){
return i;
}
}
return -1;
};
this.insert_line=function(i,line){
Quill.lib.assert((i>=0)&&(i<=this.line_count()));
var _7c3=null;
if(i<this.line_count()){
_7c3=this.lines_[i].element();
}
this.element_.insertBefore(line.element(),_7c3);
this.lines_.splice(i,0,line);
line.set_parent(this);
};
this.append_line=function(line){
this.insert_line(this.line_count(),line);
};
this.remove_line_at=function(i){
Quill.lib.assert((i>=0)&&(i<this.line_count()));
var line=this.lines_[i];
this.lines_.splice(i,1);
this.element_.removeChild(line.element());
line.set_parent(null);
return line;
};
this.remove_line=function(line){
return this.remove_line_at(this.line_index(line));
};
this.begin=function(){
return new QCursor(this,0,0,0);
};
this.end=function(){
var _7c8=this.line_count()-1;
var line=this.line(_7c8);
var _7ca=line.item_count()-1;
return new QCursor(this,_7c8,_7ca,0);
};
this.init_(ctx);
}
var _7cb={SIMPLE:"QLineType.SIMPLE",BULLET:"QLineType.BULLET"};
var _7cc={LEFT:"QAlign.LEFT",CENTER:"QAlign.CENTER",RIGHT:"QAlign.RIGHT"};
function QLineAttributes(type,_7ce,_7cf){
this.type=type;
this.level=_7ce;
this.align=_7cf;
this.merge=function(a){
if((this.type!=null)&&(this.type!=a.type)){
this.type=null;
}
if((this.level!=null)&&(this.level!=a.level)){
this.level=null;
}
if((this.align!=null)&&(this.align!=a.align)){
this.align=null;
}
};
}
function QLine(ctx,type,_7d3){
this.init_=function(ctx,type,_7d6){
this.ctx_=ctx;
this.parent_=null;
this.type_=type;
this.level_=_7d6;
this.align_=_7cc.LEFT;
this.items_=[];
this.init_elements_();
QNode.call(this);
this.set_align(this.align_);
};
this.make_core_elements_=function(){
var _7d7,_7d8;
if(this.type_==_7cb.SIMPLE){
_7d7=this.ctx_.new_element("div");
_7d8=_7d7;
}else{
var ul=this.ctx_.new_element("ul");
_7d7=ul;
ul.style.marginTop="0";
ul.style.marginBottom="0";
_7d8=this.ctx_.new_element("li");
ul.appendChild(_7d8);
}
_7d7.style.marginLeft=""+(2*this.level_)+"em";
var _7da=$(this.ctx_.root).css("white-space");
_7d7.style.whiteSpace=_7da;
return {"e_child":_7d7,"c_parent":_7d8};
};
this.init_elements_=function(){
var core=this.make_core_elements_();
this.element_=this.ctx_.new_element("span");
this.element_.appendChild(core.e_child);
this.container_=this.ctx_.new_element("span");
this.container_.style.position="relative";
core.c_parent.appendChild(this.container_);
};
this.reinit_elements_=function(){
var core=this.make_core_elements_();
this.container_.parentNode.removeChild(this.container_);
core.c_parent.appendChild(this.container_);
this.element_.replaceChild(core.e_child,this.element_.firstChild);
this.set_align(this.align_);
};
this.element=function(){
return this.element_;
};
this.parent=function(){
return this.parent_;
};
this.set_parent=function(p){
this.parent_=p;
};
this.type=function(){
return this.type_;
};
this.level=function(){
return this.level_;
};
this.set_type_and_level=function(type,_7df){
this.type_=type;
this.level_=_7df;
this.reinit_elements_();
};
this.align=function(){
return this.align_;
};
this.set_align=function(a){
this.align_=a;
var v;
if(a==_7cc.LEFT){
v="left";
}else{
if(a==_7cc.CENTER){
v="center";
}else{
if(a==_7cc.RIGHT){
v="right";
}else{
Quill.lib.assert(false,"invalid alignment: "+a);
}
}
}
this.element_.firstChild.style.textAlign=v;
};
this.get_attributes=function(){
return new QLineAttributes(this.type_,this.level_,this.align_);
};
this.set_attributes=function(a){
if((a.type!=null)||(a.level!=null)){
var _7e3=(a.type!=null)?a.type:this.type();
var _7e4=(a.level!=null)?a.level:this.level();
this.set_type_and_level(_7e3,_7e4);
}
if(a.align!=null){
this.set_align(a.align);
}
};
this.item_count=function(){
return this.items_.length;
};
this.item=function(i){
Quill.lib.assert((i>=0)&&(i<this.item_count()));
return this.items_[i];
};
this.item_index=function(item){
var n=this.item_count();
for(var i=0;i<n;++i){
if(this.items_[i]===item){
return i;
}
}
return -1;
};
this.insert_item=function(i,item){
Quill.lib.assert((i>=0)&&(i<=this.item_count()));
var _7eb=null;
if(i<this.item_count()){
_7eb=this.items_[i].element();
}
this.container_.insertBefore(item.element(),_7eb);
this.items_.splice(i,0,item);
item.set_parent(this);
};
this.append_item=function(item){
this.insert_item(this.item_count(),item);
};
this.remove_item_at=function(i){
Quill.lib.assert((i>=0)&&(i<this.item_count()));
var item=this.items_[i];
this.items_.splice(i,1);
this.container_.removeChild(item.element());
item.set_parent(null);
return item;
};
this.remove_item=function(item){
return this.remove_item_at(this.item_index(item));
};
this.init_(ctx,type,_7d3);
}
function QItemAttributes(lang,_7f1,_7f2,bold,_7f4,_7f5,_7f6,_7f7){
this.lang=lang;
this.font_name=_7f1;
this.font_size=_7f4;
this.bold=bold;
this.italic=_7f4;
this.underline=_7f5;
this.color=_7f6;
this.bg_color=_7f7;
this.merge=function(a){
if((this.lang!=null)&&(this.lang!=a.lang)){
this.lang=null;
}
if((this.font_name!=null)&&(this.font_name!=a.font_name)){
this.font_name=null;
}
if((this.font_size!=null)&&(this.font_size!=a.font_size)){
this.font_size=null;
}
if((this.bold!=null)&&(this.bold!=a.bold)){
this.bold=null;
}
if((this.italic!=null)&&(this.italic!=a.italic)){
this.italic=null;
}
if((this.underline!=null)&&(this.underline!=a.underline)){
this.underline=null;
}
if((this.underline!=null)&&(this.underline!=a.underline)){
this.underline=null;
}
if((this.color!=null)&&(this.color!=a.color)){
this.color=null;
}
if((this.bg_color!=null)&&(this.bg_color!=a.bg_color)){
this.bg_color=null;
}
};
this.set_lang=function(s){
this.lang=s;
};
this.set_font_name=function(v){
this.font_name=v;
};
this.set_font_size=function(v){
this.font_size=v;
};
this.set_bold=function(flag){
this.bold=flag;
};
this.set_italic=function(flag){
this.italic=flag;
};
this.set_underline=function(flag){
this.underline=flag;
};
this.set_color=function(_7ff){
this.color=_7ff;
};
this.set_bg_color=function(_800){
this.bg_color=_800;
};
}
function QFormat(){
this.lang_="";
this.font_name_="";
this.font_size_=14;
this.bold_=false;
this.italic_=false;
this.underline_=false;
this.color_="#000000";
this.bg_color_="#FFFFFF";
this.selection_color_=null;
this.lang=function(){
return this.lang_;
};
this.font_name=function(){
return this.font_name_;
};
this.font_size=function(){
return this.font_size_;
};
this.bold=function(){
return this.bold_;
};
this.italic=function(){
return this.italic_;
};
this.underline=function(){
return this.underline_;
};
this.color=function(){
return this.color_;
};
this.bg_color=function(){
return this.bg_color_;
};
this.selection_color=function(){
return this.selection_color_;
};
this.set_lang=function(s){
this.lang_=s;
};
this.set_font_name=function(fn){
this.font_name_=fn;
this.element().style.fontFamily=this.font_name_;
};
this.set_font_size=function(fs){
this.font_size_=fs;
this.element().style.fontSize=""+this.font_size_+"px";
};
this.set_bold=function(flag){
this.bold_=flag;
this.element().style.fontWeight=this.bold_?"bold":"normal";
};
this.set_italic=function(flag){
this.italic_=flag;
this.element().style.fontStyle=this.italic_?"italic":"normal";
};
this.set_underline=function(flag){
this.underline_=flag;
this.element().style.textDecoration=this.underline_?"underline":"none";
};
this.update_color_=function(){
var c=(this.selection_color_==null)?this.color_:Quill.lib.blend(this.color_,this.selection_color_,0.35);
this.element().style.color=c;
};
this.update_background_=function(){
var c=(this.selection_color_==null)?this.bg_color_:Quill.lib.blend(this.bg_color_,this.selection_color_,0.35);
this.element().style.backgroundColor=c;
};
this.set_color=function(v){
this.color_=v;
this.update_color_();
};
this.set_bg_color=function(v){
this.bg_color_=v;
this.update_background_();
};
this.set_selection_color=function(v){
this.selection_color_=v;
this.update_color_();
this.update_background_();
};
this.set_font_size(this.font_size_);
this.get_attributes=function(){
return new QItemAttributes(this.lang_,this.font_name_,this.font_size_,this.bold_,this.italic_,this.underline_,this.color_,this.bg_color_);
};
this.set_attributes=function(a){
if(a.lang!=null){
this.set_lang(a.lang);
}
if(a.font_name!=null){
this.set_font_name(a.font_name);
}
if(a.font_size!=null){
this.set_font_size(a.font_size);
}
if(a.bold!=null){
this.set_bold(a.bold);
}
if(a.italic!=null){
this.set_italic(a.italic);
}
if(a.underline!=null){
this.set_underline(a.underline);
}
if(a.color!=null){
this.set_color(a.color);
}
if(a.bg_color!=null){
this.set_bg_color(a.bg_color);
}
};
}
function QItem(ctx){
this.init_=function(ctx){
this.ctx_=ctx;
this.element_=this.ctx_.new_element("span");
this.parent_=null;
if($.browser.msie){
this.element_.style.display="inline-block";
}
QFormat.call(this);
QNode.call(this);
};
this.element=function(){
return this.element_;
};
this.parent=function(){
return this.parent_;
};
this.set_parent=function(p){
this.parent_=p;
};
this.set_content_=function(s){
var e=this.element_;
while(e.firstChild){
e.removeChild(e.firstChild);
}
this.element_.appendChild(this.ctx_.new_text_node(s));
};
this.set_selected_all=function(_812){
var _813=_812?"#316AC5":"#000000";
this.set_selection_color(_813);
};
this.set_selected_none=function(){
this.set_selection_color(null);
};
this.init_(ctx);
}
function QTextItem(ctx,s){
this.init_=function(ctx,s){
this.is_QTextItem=true;
QItem.call(this,ctx);
if(s==_78f){
this.element_.style.display="";
}
this.set_text(s);
};
this.text=function(){
return this.text_;
};
this.set_text=function(s){
this.text_=s;
this.set_content_(s);
var self=this;
function notify_callback(){
self.ctx_.on_xlit_update();
}
setTimeout(notify_callback,0);
};
this.init_(ctx,s);
}
function QXlitItem(ctx){
this.init_=function(ctx){
this.is_QXlitItem=true;
QItem.call(this,ctx);
this.element().style.padding="1px";
this.set_lang=this.set_lang_for_xlit;
this.english_="";
this.options_=[];
this.index_=0;
this.request_=null;
this.editor_id_=null;
};
this.english=function(){
return this.english_;
};
this.options=function(){
return this.options_;
};
this.index=function(){
return this.index_;
};
this.is_updating=function(){
return this.request_!==null;
};
this.set_english=function(s){
this.english_=s;
};
this.set_lang_for_xlit=function(s){
if(this.lang_!=s&&this.lang_!=""){
this.lang_=s;
this.update_xlit();
}
this.lang_=s;
};
this.set_options=function(a){
this.options_=a;
};
this.set_index=function(i){
this.index_=i;
};
this.get_text_=function(){
if((this.english_.length==0)||(this.lang_.length==0)){
return "-";
}
if(this.lang_=="english"){
return this.english_;
}
var t="";
if((this.index_>=0)&&(this.index_<this.options_.length)){
t=this.options_[this.index_];
}
if(this.is_updating()){
t+=".";
}
return t;
};
this.update_text=function(){
this.set_content_(this.get_text_());
var self=this;
function notify_callback(){
self.ctx_.on_xlit_update();
}
setTimeout(notify_callback,0);
};
this.update_xlit=function(){
if(this.english_.charCodeAt(this.english_.length-1)>127){
this.options_=[this.english_];
this.update_text();
return;
}
if(this.request_!=null){
var _822=Quill.getObject(this.editor_id_).editor_;
this.request_.cancel();
this.request_=null;
}
if((this.english_=="")||(this.lang_=="")||(this.lang_=="english")){
this.options_=[];
this.index_=0;
}else{
var _823=Quill.getInscriptMode(this.editor_id_);
if(!this.editor_id_){
this.editor_id_=ctx.root.id.replace(/_div$/,"");
this.editor_id_=this.editor_id_.replace(/^Quill/,"");
}
var _823=Quill.getInscriptMode(this.editor_id_);
var _822=Quill.getObject(this.editor_id_).editor_;
this.request_=new Quill.lib.QuillRequest(this.lang_,this.english_,Quill.lib.bind_this(this,this.on_response_),_823,_822);
}
this.update_text();
};
this.on_response_=function(_824,_825,_826){
this.request_=null;
function has_uppercase_char(str){
for(var i=1;i<str.length;i++){
if(str.charCodeAt(i)>=65&&str.charCodeAt(i)<=90){
return true;
}
}
return false;
}
function has_lowercase_char(str){
for(var i=1;i<str.length;i++){
if(str.charCodeAt(i)>=97&&str.charCodeAt(i)<=122){
return true;
}
}
return false;
}
function contains_itrans_option(opts,_82c){
for(var i=0;i<opts.length;i++){
if(opts[i]==_82c){
return true;
}
}
return false;
}
if(!contains_itrans_option(_824,_825)){
if(has_uppercase_char(this.english_)&&has_lowercase_char(this.english_)){
_824.unshift(_825);
}else{
_824.push(_825);
}
}
this.options_=_824;
this.index_=0;
this.update_text();
};
this.choose_option=function(_82e){
this.index_=_82e;
this.update_text();
};
this.get_text=function(){
return this.get_text_();
};
this.init_(ctx);
}
function QDocFragment(_82f,_830){
this.initial=_82f;
this.lines=_830;
}
function QDFLine(_831,attr){
this.items=_831;
this.attr=attr;
}
function QDFText(text,attr){
this.is_QDFText=true;
this.text=text;
this.attr=attr;
this.get_text=function(){
return this.text;
};
}
function QDFXlit(_835,attr,_837,_838,_839){
this.is_QDFXlit=true;
this.english=_835;
this.attr=attr;
this.options=_837;
this.index=_838;
this.is_updating=_839;
this.get_text=function(){
if(this.english.length==0){
return "-";
}
if(this.is_updating){
return ".";
}
if((this.index>=0)&&(this.index<this.options.length)){
return this.options[this.index];
}
return ".";
};
this.get_english=function(){
return this.english;
};
}
function item_to_df_(item){
Quill.lib.assert(item.is_QTextItem||item.is_QXlitItem);
if(item.is_QTextItem){
return new QDFText(item.text(),item.get_attributes());
}else{
return new QDFXlit(item.english(),item.get_attributes(),item.options(),item.index(),item.is_updating());
}
}
function QCursor(doc,u,v){
this.doc=doc;
this.u=u;
this.v=v;
this.clone=function(){
return new QCursor(this.doc,this.u,this.v);
};
this.compare=function(_83e){
if(this.u<_83e.u){
return -1;
}
if(this.u>_83e.u){
return 1;
}
if(this.v<_83e.v){
return -1;
}
if(this.v>_83e.v){
return 1;
}
return 0;
};
this.equals=function(_83f){
return this.compare(_83f)==0;
};
this.not_equals=function(_840){
return this.compare(_840)!=0;
};
this.lesser=function(_841){
return this.compare(_841)<0;
};
this.lesser_equal=function(_842){
return this.compare(_842)<=0;
};
this.greater=function(_843){
return this.compare(_843)>0;
};
this.greater_equal=function(_844){
return this.compare(_844)>=0;
};
this.line=function(){
return this.doc.line(this.u);
};
this.item=function(){
var line=this.line();
return line.item(this.v);
};
this.previous_item=function(){
Quill.lib.assert(!this.is_line_begin());
var line=this.line();
return line.item(this.v-1);
};
this.is_xlit=function(){
if(this.item().is_QXlitItem){
return true;
}else{
return false;
}
};
this.has_previous_xlit=function(){
if(!this.is_line_begin()&&(this.previous_item().is_QXlitItem)){
return true;
}else{
return false;
}
};
this.is_line_begin=function(){
return this.v==0;
};
this.is_line_end=function(){
var line=this.doc.line(this.u);
return this.v==line.item_count()-1;
};
this.is_first_line=function(){
return this.u==0;
};
this.is_last_line=function(){
return this.u==this.doc.line_count()-1;
};
this.is_begin=function(){
return this.is_first_line()&&this.is_line_begin();
};
this.is_end=function(){
return this.is_last_line()&&this.is_line_end();
};
this.go_line_begin=function(){
this.v=0;
};
this.go_line_end=function(){
var line=this.doc.line(this.u);
this.v=line.item_count()-1;
};
this.go_next=function(){
if(this.is_line_end()){
this.u++;
this.go_line_begin();
}else{
this.v++;
}
};
this.go_previous=function(){
if(this.is_line_begin()){
if(!this.is_begin()){
this.u--;
}
this.go_line_end();
}else{
this.v--;
}
};
this.go_next_line=function(){
this.u++;
this.go_line_begin();
};
this.go_previous_line=function(){
this.u--;
this.go_line_begin();
};
this.go_begin=function(){
this.u=0;
this.v=0;
};
this.go_end=function(){
this.u=this.doc.line_count()-1;
this.go_line_end();
};
this.get_rect=function(){
var rect;
if((!this.is_line_begin())&&this.is_line_end()){
rect=this.previous_item().get_rect();
return new QRect(rect.right(),rect.top(),0,rect.height());
}
rect=this.item().get_rect();
return new QRect(rect.left(),rect.top(),0,rect.height());
};
}
function QOpAddFragment(_84a,_84b){
this.cursor=_84a;
this.fragment=_84b;
this.add_item_=function(ctx,_84d,_84e){
var item;
if(_84e.is_QDFXlit){
item=ctx.new_xlit_item();
item.set_english(_84e.english);
item.set_options(_84e.options);
item.set_index(_84e.index);
item.set_attributes(_84e.attr);
if(_84e.is_updating){
item.update_xlit();
}
item.update_text();
}else{
if(_84e.is_QDFText){
item=ctx.new_text_item(_84e.text);
item.set_attributes(_84e.attr);
}else{
Quill.lib.assert(false);
}
}
_84d.line().insert_item(_84d.v,item);
};
this.add_blank_line_=function(ctx,_851,_852){
var a=_852.attr;
var line=ctx.new_line(a.type,a.level);
line.set_align(a.align);
line.append_item(ctx.new_text_item(_78f));
ctx.doc.insert_line(_851,line);
};
this.perform=function(ctx){
var c=this.cursor.clone();
var i,j;
for(i=0;i<_84b.initial.length;++i){
this.add_item_(ctx,c,_84b.initial[i]);
c.v++;
}
var c2=c.clone();
for(i=0;i<_84b.lines.length;++i){
var line=_84b.lines[i];
this.add_blank_line_(ctx,c2.u+1,line);
c2.go_next_line();
for(j=0;j<line.items.length;++j){
this.add_item_(ctx,c2,line.items[j]);
c2.v++;
}
}
if(_84b.lines.length>0){
while(!c.is_line_end()){
var item=c.line().remove_item_at(c.v);
c2.line().insert_item(c2.v,item);
c2.v++;
}
}
};
this.get_ending_cursor=function(ctx){
var _85d=this.fragment.lines.length;
var _85e=this.cursor.u+_85d;
var _85f;
if(_85d>0){
_85f=this.fragment.lines[_85d-1].items.length;
}else{
_85f=this.cursor.v+this.fragment.initial.length;
}
return new QCursor(ctx.doc,_85e,_85f);
};
this.perform_and_invert=function(ctx){
this.perform(ctx);
return new QOpDelFragment(this.cursor,this.get_ending_cursor(ctx));
};
}
function QOpDelFragment(_861,_862){
this.cursor1=_861;
this.cursor2=_862;
this.perform=function(ctx){
this.perform_and_invert(ctx);
};
this.move_items_=function(_864,_865,i,j){
var _868=j-i;
for(;_868>0;--_868){
var item=_865.remove_item_at(i);
_864.push(item_to_df_(item));
}
};
this.move_items_till_line_end_=function(_86a,_86b){
var line=_86b.line();
var end=_86b.clone();
end.go_line_end();
this.move_items_(_86a,line,_86b.v,end.v);
};
this.perform_and_invert=function(ctx){
var _86f=new QDocFragment([],[]);
var c=this.cursor1.clone();
var _871=this.cursor2.u-c.u;
if(_871==0){
this.move_items_(_86f.initial,c.line(),c.v,this.cursor2.v);
}else{
this.move_items_till_line_end_(_86f.initial,c);
c.go_next_line();
for(;_871>0;--_871){
var line=c.line();
var _873=new QDFLine([],line.get_attributes());
_86f.lines.push(_873);
if(_871>1){
this.move_items_till_line_end_(_873.items,c);
}else{
this.move_items_(_873.items,line,c.v,this.cursor2.v);
var _874=this.cursor1.clone();
while(!c.is_line_end()){
var item=line.remove_item_at(c.v);
_874.line().insert_item(_874.v,item);
_874.v++;
}
}
ctx.doc.remove_line_at(c.u);
}
}
return new QOpAddFragment(this.cursor1,_86f);
};
}
function QOpChangeXlitItem(_876,_877,_878,_879,_87a){
this.cursor=_876;
this.english=_877;
this.options=_878;
this.index=_879;
this.should_update=_87a;
this.perform=function(ctx){
var item=this.cursor.item();
item.set_english(this.english);
item.set_options(this.options);
item.set_index(this.index);
if(this.should_update){
item.update_xlit();
}
item.update_text();
};
this.perform_and_invert=function(ctx){
var item=this.cursor.item();
var inv=new QOpChangeXlitItem(this.cursor,item.english(),item.options(),item.index(),item.is_updating());
this.perform(ctx);
return inv;
};
}
function QOpFormatItem(_880,_881){
this.cursor=_880;
this.item_attributes=_881;
this.perform=function(ctx){
this.cursor.item().set_attributes(this.item_attributes);
};
this.perform_and_invert=function(ctx){
var item=this.cursor.item();
var inv=new QOpFormatItem(this.cursor,item.get_attributes());
this.perform(ctx);
return inv;
};
}
function QOpFormatLine(_886,_887){
this.line_index=_886;
this.line_attributes=_887;
this.perform=function(ctx){
ctx.doc.line(_886).set_attributes(this.line_attributes);
};
this.perform_and_invert=function(ctx){
var line=ctx.doc.line(this.line_index);
var inv=new QOpFormatLine(this.line_index,line.get_attributes());
this.perform(ctx);
return inv;
};
}
function QOpGroup(ops){
this.ops=ops;
this.perform=function(ctx){
for(var i=0;i<this.ops.length;++i){
this.ops[i].perform(ctx);
}
};
this.perform_and_invert=function(ctx){
var _890=[];
for(var i=0;i<this.ops.length;++i){
var _892=this.ops[i].perform_and_invert(ctx);
_890.push(_892);
}
_890.reverse();
return new QOpGroup(_890);
};
}
function QuillPopup(hdoc,_894){
this.init_=function(hdoc,_896){
this.hdoc_=hdoc;
this.choice_callback_=_896;
var e=this.hdoc_.createElement("div");
e.style.position="absolute";
e.style.border="1px solid #40759C";
e.style.background="#F4F6FF";
e.style.zIndex=100;
var _898=this.hdoc_.createElement("iframe");
$(_898).css({"position":"absolute","visibility":"hidden","opacity":0,"border":"none","margin":0,"padding":0,"width":"0px","height":"0px","left":"-999em","top":"-999em","z-index":0,"display":"block"});
this.hdoc_.body.appendChild(e);
this.hdoc_.body.appendChild(_898);
this.element_=e;
this.iframe_=_898;
this.container_=e;
this.visible_=true;
this.set_visible_(false);
this.offset_x_=0;
this.offset_y_=0;
this.demo=false;
this.max_options_=Quill.lib.isSet(Quill.Config,"client","maxWordOptions",4);
this.disabled_=!Quill.lib.isSet(Quill.Config,"client","showOptionPanel",true);
this.editor_;
};
this.set_editor=function(ed){
this.editor_=ed;
};
this.set_offset=function(ox,oy){
this.offset_x_=ox;
this.offset_y_=oy;
};
this.clear_=function(){
var e=this.container_;
while(e.firstChild){
e.removeChild(e.firstChild);
}
};
this.set_visible_=function(flag){
if(flag&&!this.disabled_){
if(this.visible_){
return;
}
this.visible_=true;
this.element_.style.visibility="visible";
this.iframe_.style.visibility="visible";
}else{
if(!this.visible_){
return;
}
this.visible_=false;
this.element_.style.visibility="hidden";
this.iframe_.style.visibility="hidden";
this.clear_();
}
};
this.show=function(){
this.set_visible_(true);
};
this.hide=function(){
this.set_visible_(false);
};
this.add_english_=function(s){
var d=this.hdoc_.createElement("div");
d.style.background="#86ABD5";
d.style.padding="3px";
var e=this.hdoc_.createElement("span");
e.style.fontSize="8pt";
if(this.demo){
e.style.color="red";
}else{
e.style.color="#404040";
}
e.style.paddingLeft="10px";
e.style.paddingRight="10px";
e.style.fontFamily="sans-serif";
e.appendChild(this.hdoc_.createTextNode(s));
d.appendChild(e);
this.container_.appendChild(d);
};
this.add_option_=function(s,_8a2,_8a3){
var d=this.hdoc_.createElement("div");
d.style.background="transparent";
var e=this.hdoc_.createElement("span");
if(_8a2==_8a3.index()){
e.style.fontWeight="bold";
}
e.style.fontSize="10pt";
e.style.color="#000000";
e.style.paddingLeft="10px";
e.style.paddingRight="10px";
e.style.lineHeight="20px";
e.appendChild(this.hdoc_.createTextNode(s));
d.appendChild(e);
this.container_.appendChild(d);
var self=this;
$(e).hover(function(){
d.style.background="#DAE9FB";
},function(){
d.style.background="transparent";
});
$(e).mousedown(function(evt){
evt.stopPropagation();
evt.preventDefault();
_8a3.choose_option(_8a2);
window.setTimeout(self.choice_callback_,0);
});
};
this.update_position_=function(_8a8){
var ifr=this.editor_.find_xy();
this.offset_x_=ifr.left;
this.offset_y_=ifr.top;
var e=this.element_;
var _8ab=this.iframe_;
var r=_8a8.get_rect();
item_position=$(_8a8.element_).offset();
item_height=$(_8a8.element_).height();
var left,top;
if($.browser.msie||Quill.lib.isMobile){
var _8af=item_position.top+item_height+10;
top=_8af;
left=new_rect.left;
}else{
left=""+(r.left()-this.editor_.get_scroll("VERTICAL")+10+this.offset_x_);
top=""+(r.bottom()-this.editor_.get_scroll("HORIZONTAL")+10+this.offset_y_);
}
e.style.left=left+"px";
e.style.top=top+"px";
_8ab.style.left=left+"px";
_8ab.style.top=top+"px";
_8ab.style.width=e.offsetWidth+"px";
_8ab.style.height=e.offsetHeight+"px";
};
this.update=function(_8b0){
this.clear_();
this.add_english_(_8b0.english());
var _8b1=_8b0.options();
for(var i=0;i<_8b1.length&&i<this.max_options_;++i){
this.add_option_(_8b1[i],i,_8b0);
}
this.update_position_(_8b0);
};
this.disable=function(val){
this.disabled_=val;
};
this.init_(hdoc,_894);
}
function QuillEditor(_8b4,root,_8b6,lang,win,_8b9,_8ba,_8bb){
this.init_=function(_8bc,root,_8be,win,_8c0,_8c1,_8c2){
this.ctx_=new QDocContext(_8bc,root);
this.ctx_.add_xlit_update_callback(Quill.lib.bind_this(this,this.update_on_resize));
this.doc_=this.ctx_.doc;
var line=this.ctx_.new_line(_7cb.SIMPLE,0);
line.append_item(this.ctx_.new_text_item(_78f));
this.doc_.append_line(line);
this.transient_attributes_=null;
this.blink_on_count_=0;
this.anchor_=null;
this.caret_=new QCursor(this.doc_,0,0);
this.caret_on_word_=false;
this.on_which_word_=null;
this.has_focus_=false;
this.undo_list_=[];
this.redo_list_=[];
this.internal_clipboard;
this.external_clipboard="";
this.window_=win;
this.ignore_on_resize=false;
this.caret_widget_=this.ctx_.new_element("div");
this.caret_widget_.style.position="absolute";
this.caret_widget_.style.fontSize="0px";
this.caret_widget_.style.background="#000000";
this.ctx_.html_doc.body.appendChild(this.caret_widget_);
this.popup_=_8be;
this.popup_.hide();
this.popup_.set_editor(this);
this.popup_enabled_=false;
this.char_count=0;
this.char_count_span=$("#"+_8c0)[0];
this.max_char_count=Quill.lib.isSet(Quill.Config,"client","charlimit",-1);
this.update_on_move();
this.enter_callback_=null;
this.focus_callback_=null;
this.textarea_update_callback_=null;
this.lang_font_={"bengali":"Vrinda","gujarati":"Shruti","hindi":"Mangal","kannada":"Tunga","malayalam":"Kartika","marathi":"Mangal","tamil":"Latha","telugu":"Gautami","punjabi":"Raavi","nepali":"Mangal","english":"museo-sans"};
this.init_lang_=lang.toLowerCase();
this.init_font_="Arial";
this.init_font_size_=14;
if(this.lang_font_[this.init_lang_]){
this.init_font_=this.lang_font_[this.init_lang_];
}
this.init_font_size_=Quill.lib.font_size(this.init_lang_).replace(/px/i,"");
this.SPACE_CHAR=$.browser.msie?"\xa0":" ";
this.last_lang_font={"lang":"english","font":"Arial"};
this.present_lang_font={"lang":this.init_lang_,"font":this.init_font_};
this.has_prefill_text=false;
this.inscript_mode=false;
this.timedOutRequest=0;
this.is_textArea=_8c1;
this.waiting_request={};
this.statusMessage=null;
this.input_listener=_8c2;
this.on_started_typing_callback=null;
SCROLL_BAR_WIDTH=scrollbarWidth();
};
this.grab_focus=function(){
if(this.has_prefill_text){
this.has_prefill_text=false;
this.clear_doc();
}
if(this.focus_callback_){
this.focus_callback_();
}
if(!this.has_focus_&&!(Quill.lib.isiOS||Quill.lib.isAndroid)){
this.ctx_.root.focus();
this.set_has_focus(true);
}
$(this.input_listener).focus();
};
this.has_focus=function(){
return this.has_focus_;
};
this.toggle_caret_blink=function(){
if(this.blink_on_count_>0){
this.blink_on_count_--;
}else{
this.blink_on_count_++;
}
this.update_caret_visibility();
};
this.update_last_known_lang=function(lang,font){
this.last_lang_font=this.present_lang_font;
if(font){
this.present_lang_font={"lang":lang,"font":font};
}else{
var _8c6="Arial";
if(this.lang_font_[default_lang]){
_8c6=this.lang_font_[this.init_lang_];
}
this.present_lang_font={"lang":lang,"font":_8c6};
}
};
this.toggle_lang=function(){
this.set_lang(this.last_lang_font.lang);
this.set_font_name(this.last_lang_font.font);
this.update_caret_widget();
var temp=this.present_lang_font;
this.present_lang_font=this.last_lang_font;
this.last_lang_font=temp;
this.grab_focus();
};
this.set_has_focus=function(flag){
this.has_focus_=flag;
if(this.anchor_){
this.add_selection_highlight_();
}
this.update_caret_visibility();
if(this.has_focus_){
this.update_caret_widget();
}
};
this.set_anchor=function(val){
this.anchor_=val;
this.update_caret_visibility();
};
this.update_caret_visibility=function(){
if((this.blink_on_count_>0)&&this.has_focus_&&((this.anchor_==null)||this.anchor_.equals(this.caret_))){
this.caret_widget_.style.background="#000000";
}else{
this.caret_widget_.style.background="transparent";
}
};
this.cursor_attributes=function(_8ca){
if(!_8ca.is_line_begin()){
return _8ca.previous_item().get_attributes();
}
if(!_8ca.is_line_end()){
return _8ca.item().get_attributes();
}
return null;
};
this.default_attributes=function(_8cb){
return new QItemAttributes(this.init_lang_,this.init_font_,this.init_font_size_,false,false,false,"#555555","#FFFFFF");
};
this.set_transient_attributes=function(a){
this.transient_attributes_=a;
};
this.unset_transient_attributes=function(){
this.transient_attributes_=null;
};
this.disable_popup=function(val){
this.popup_.disable(val);
};
this.set_enter_callback=function(func){
this.enter_callback_=func;
};
this.set_focus_callback=function(func){
this.focus_callback_=func;
};
this.set_textarea_update_callback=function(func){
this.textarea_update_callback_=func;
this.ctx_.add_xlit_update_callback(func);
};
this.update_textarea=function(){
if(this.textarea_update_callback_){
this.textarea_update_callback_();
}
};
this.get_new_item_attributes=function(){
if(this.transient_attributes_){
return this.transient_attributes_;
}
var c=this.caret_;
if(this.caret_on_word_){
c=this.on_which_word_.clone();
c.go_next();
}
var a=this.cursor_attributes(c);
if(a){
a.lang=this.init_lang_;
}
if(!a){
return this.default_attributes();
}
return a;
};
this.get_selection_item_attributes=function(){
if(this.anchor_==null){
return null;
}
var c1=this.anchor_.clone();
var c2=this.caret_.clone();
if(c1.greater(c2)){
var temp=c1;
c1=c2;
c2=temp;
}
while(c1.is_line_end()&&(c1.not_equals(c2))){
c1.go_next();
}
if(c1.equals(c2)){
return null;
}
var a=c1.item().get_attributes();
c1.go_next();
while(c1.not_equals(c2)){
if(!c1.is_line_end()){
a.merge(c1.item().get_attributes());
}
c1.go_next();
}
return a;
};
this.get_line_attributes=function(){
var _8d7=this.caret_.u;
var _8d8=_8d7;
if(this.anchor_!=null){
_8d8=this.anchor_.u;
if(_8d7>_8d8){
var temp=_8d7;
_8d7=_8d8;
_8d8=temp;
}
}
var a=this.doc_.line(_8d7).get_attributes();
while(_8d7<_8d8){
++_8d7;
var b=this.doc_.line(_8d7).get_attributes();
a.merge(b);
}
return a;
};
this.update_input_listener=function(top_,_8dd){
if(this.input_listener&&!_8dd){
$(this.input_listener).css("top","0px");
}
};
this.update_caret_widget=function(){
var cw=this.caret_widget_;
var rect,item;
var win=window;
var doc=document;
ie_doc=this.window_;
doc=this.ctx_.html_doc;
win=this.ctx_.html_doc.parentWindow?this.ctx_.html_doc.parentWindow:this.ctx_.html_doc;
if(this.caret_on_word_){
item=this.on_which_word_.item();
rect=item.get_rect();
new_rect=$(item.element_).offset();
}else{
rect=this.caret_.get_rect();
new_rect=$(this.caret_.item().element_).offset();
id=$(this.caret_.item().element_).attr("id");
}
function get_window_dimensions(side){
if($.browser.msie||Quill.lib.isMobile){
return (side=="HEIGHT")?$(ie_doc).height():$(ie_doc).width();
}
var _8e4=0;
if(typeof (win.innerWidth)=="number"){
_8e4=(side=="HEIGHT")?win.innerHeight:win.innerWidth;
}else{
if(doc.documentElement&&(doc.documentElement.clientWidth||doc.documentElement.clientHeight)){
_8e4=(side=="HEIGHT")?doc.documentElement.clientHeight:doc.documentElement.clientWidth;
}else{
if(doc.body&&(doc.body.clientWidth||doc.body.clientHeight)){
_8e4=(side=="HEIGHT")?doc.body.clientHeight:doc.body.clientWidth;
}
}
}
return _8e4;
}
function get_scroll(axis){
function non_ie(axis){
var _8e7=0;
if(typeof (win.pageYOffset)=="number"){
_8e7=(axis=="HORIZONTAL")?win.pageYOffset:win.pageXOffset;
}else{
if(doc.body&&(doc.body.scrollLeft||doc.body.scrollTop)){
_8e7=(axis=="HORIZONTAL")?doc.body.scrollTop:doc.body.scrollLeft;
}else{
if(doc.documentElement&&(doc.documentElement.scrollLeft||doc.documentElement.scrollTop)){
_8e7=(axis=="HORIZONTAL")?doc.documentElement.scrollTop:doc.documentElement.scrollLeft;
}
}
}
return _8e7;
}
function ie(axis){
var _8e9=0;
if(ie_doc&&(ie_doc.scrollTop||ie_doc.scrollLeft)){
_8e9=(axis=="HORIZONTAL")?ie_doc.scrollLeft:ie_doc.scrollTop;
}else{
if(ie_doc.documentElement&&(ie_doc.documentElement.scrollLeft||ie_doc.documentElement.scrollTop)){
_8e9=(axis=="HORIZONTAL")?ie_doc.documentElement.scrollLeft:doc.documentElement.scrollTop;
}
}
return _8e9;
}
return ($.browser.msie||Quill.lib.isMobile)?ie(axis):non_ie(axis);
}
var _8ea=get_window_dimensions("HEIGHT");
var _8eb=get_scroll("HORIZONTAL");
var _8ec=get_window_dimensions("WIDTH");
var _8ed=get_scroll("VERTICAL");
var _8ee=0;
var _8ef=_8ea;
var _8f0=_8ec;
var that=this;
function scroll_to_focus(){
if($.browser.msie||Quill.lib.isMobile){
var _8f2=new_rect.top;
var _8f3=_8f2+rect.height();
var _8f4=$(that.window_).offset().top;
var _8f5=_8f4+$(that.window_).height();
if(_8f2<_8f4){
var diff=_8f4-_8f2;
$(ie_doc).scrollTop(_8ed-diff);
}else{
if(_8f3>_8f5){
var diff=_8f3-_8f5;
$(ie_doc).scrollTop(_8ed+diff);
}
}
}else{
if(rect.top()<_8eb){
var c=that.caret_.clone();
for(var i=0;i<_8ee;++i){
if(!c.is_first_line()){
c.go_previous_line();
}
}
that.window_.scrollBy(0,-1*(_8eb-rect.top()));
}else{
if(rect.bottom()>_8eb+_8ea){
var c=that.caret_.clone();
for(var i=0;i<_8ee;++i){
if(!c.is_last_line()){
c.go_next_line();
}
}
that.window_.scrollBy(0,rect.bottom()-(_8eb+_8ea));
}
}
if(rect.left()<_8ed){
that.window_.scrollBy(-1*(_8ed-rect.left()),0);
}else{
if(rect.left()+rect.width()>_8ed+_8ec){
var c=that.caret_.clone();
c.go_previous();
var s=rect.left()+rect.width()-(_8ed+_8ec)+5;
that.window_.scrollBy(s,0);
}
}
}
}
var _8fa,_8fb;
var _8fc=0;
if(ie_doc.scrollTop>0){
_8fc=SCROLL_BAR_WIDTH;
}
scroll_to_focus();
if(this.caret_on_word_){
item=this.on_which_word_.item();
rect=item.get_rect();
new_rect=$(item.element_).offset();
item_position=$(item.element_).position();
}else{
rect=this.caret_.get_rect();
new_rect=$(this.caret_.item().element_).offset();
item_position=$(this.caret_.item().element_).position();
id=$(this.caret_.item().element_).attr("id");
}
if(this.caret_on_word_){
item=this.on_which_word_.item();
rect=item.get_rect();
if($.browser.msie||Quill.lib.isMobile){
_8fb=item_position.top+rect.height();
_8fa=item_position.left;
}else{
_8fa=(rect.left()-1);
_8fb=(rect.bottom()-2);
}
cw.style.left=""+_8fa+"px";
cw.style.top=""+_8fb+"px";
cw.style.height="1px";
cw.style.width=""+(2+rect.width())+"px";
this.popup_.update(item);
if(this.has_focus_&&this.popup_enabled_){
this.popup_.show();
}
}else{
item=this.caret_.item();
rect=this.caret_.get_rect();
if($.browser.msie||Quill.lib.isMobile){
_8fb=item_position.top;
_8fa=item_position.left;
}else{
_8fa=rect.left();
_8fb=rect.top();
}
cw.style.top=""+_8fb+"px";
cw.style.left=""+_8fa+"px";
cw.style.height=""+rect.height()+"px";
cw.style.width="2px";
this.popup_.hide();
}
$(this.caret_widget_).remove();
$(this.caret_.line().container_).append(this.caret_widget_);
this.update_input_listener(_8fb,this.caret_on_word_);
};
this.update_on_move=function(_8fd){
this.blink_on_count_=2;
this.update_caret_visibility();
this.update_caret_widget();
if(!_8fd){
this.unset_transient_attributes();
}
};
this.update_on_resize=function(){
if(this.ignore_on_resize){
return;
}
refresh_get_rect();
this.update_caret_widget();
this.update_char_count();
};
this.get_nearest_line=function(x,y){
var n=this.doc_.line_count();
Quill.lib.assert(n>0);
var _901=0;
var line=this.doc_.line(_901);
var rect=line.get_rect();
var _904=rect.y_distance(y);
for(var i=1;i<n;++i){
var _906=this.doc_.line(i);
var _907=_906.get_rect();
var _908=_907.y_distance(y);
if(_908>_904){
break;
}else{
if(_908<_904){
_901=i;
line=_906;
rect=_907;
_904=_908;
}
}
}
return _901;
};
this.get_nearest_cursor_in_range=function(_909,end,x,y){
Quill.lib.assert(_909.lesser_equal(end));
var c=_909.clone();
var rect=c.get_rect();
var _90f=rect.y_distance(y);
var _910=rect.x_distance(x);
var _911=c.clone();
while(c.not_equals(end)){
c.go_next();
var _912=c.get_rect();
var _913=_912.y_distance(y);
if(_913<_90f){
_911=c.clone();
rect=_912;
_90f=_913;
_910=_912.x_distance(x);
}else{
if(_913==_90f){
var _914=_912.x_distance(x);
if(_914<_910){
_911=c.clone();
rect=_912;
_90f=_913;
_910=_914;
}
}
}
}
return _911;
};
this.get_nearest_cursor=function(x,y){
var _917=this.get_nearest_line(x,y);
var _918=new QCursor(this.doc_,_917,0);
var end=_918.clone();
end.go_line_end();
return this.get_nearest_cursor_in_range(_918,end,x,y);
};
this.update_selection_highlight_=function(c1,c2,_91c){
if(c1.greater(c2)){
var temp=c1;
c1=c2;
c2=temp;
}
var c=c1.clone();
while(c.not_equals(c2)){
if(_91c){
c.item().set_selected_all(this.has_focus_);
}else{
c.item().set_selected_none();
}
c.go_next();
}
};
this.add_selection_highlight_=function(){
this.update_selection_highlight_(this.anchor_,this.caret_,true);
};
this.remove_selection_highlight_=function(){
this.update_selection_highlight_(this.anchor_,this.caret_,false);
};
this.move_caret_to_xy=function(x,y,_921){
var _922=(this.anchor_!=null);
var _923=this.get_nearest_cursor(x,y);
var _924=false;
if(_923.equals(this.caret_)){
_924=true;
}
if(_923.equals(this.caret_)&&_921&&_922){
return;
}
if(_922){
this.remove_selection_highlight_();
if(!_921){
this.set_anchor(null);
}
}
if(_921&&!this.anchor_){
this.set_anchor(this.caret_.clone());
}
this.caret_on_word_=false;
this.on_which_word_=null;
if(!_921){
if(_923.is_xlit()&&_923.item().get_rect().contains(x,y)){
this.caret_on_word_=true;
this.on_which_word_=_923.clone();
this.popup_enabled_=true;
}else{
if(_923.has_previous_xlit()&&(_923.previous_item().get_rect().contains(x,y))){
this.caret_on_word_=true;
this.on_which_word_=_923.clone();
this.on_which_word_.go_previous();
this.popup_enabled_=true;
}
}
}
this.caret_=_923;
if(this.caret_on_word_){
item=this.on_which_word_.item();
rect=item.get_rect();
}else{
rect=this.caret_.get_rect();
}
this.update_on_move(_924);
if(_921){
this.add_selection_highlight_();
}
};
this.MOVING_LEFT="MOVING_LEFT";
this.MOVING_RIGHT="MOVING_RIGHT";
this.adjust_caret_before_select_=function(_925){
if(!this.caret_on_word_){
return;
}
this.caret_on_word_=false;
this.caret_=this.on_which_word_;
this.on_which_word_=null;
Quill.lib.assert(this.caret_.is_xlit());
switch(_925){
case this.MOVING_LEFT:
this.caret_=this.caret_.clone();
this.caret_.go_next();
break;
case this.MOVING_RIGHT:
break;
default:
Quill.lib.assert(false);
}
};
this.prepare_before_move_=function(_926,_927){
if(_926){
if(this.anchor_==null){
this.adjust_caret_before_select_(_927);
this.set_anchor(this.caret_.clone());
}else{
this.remove_selection_highlight_();
}
}else{
if(this.anchor_!=null){
this.remove_selection_highlight_();
this.set_anchor(null);
}
}
this.popup_enabled_=false;
this.popup_.hide();
};
this.move_left=function(_928){
this.prepare_before_move_(_928,this.MOVING_LEFT);
var _929=false;
var _92a=this.caret_;
if(this.caret_on_word_){
this.caret_on_word_=false;
this.caret_=this.on_which_word_;
this.on_which_word_=null;
}else{
if(!this.caret_.is_begin()){
this.caret_=this.caret_.clone();
this.caret_.go_previous();
if((!_928)&&this.caret_.is_xlit()){
this.caret_on_word_=true;
this.on_which_word_=this.caret_;
}
}
}
if(_928){
this.add_selection_highlight_();
}
if(_92a.equals(this.caret_)){
_929=true;
}
this.update_on_move(_929);
};
this.move_right=function(_92b){
this.prepare_before_move_(_92b,this.MOVING_RIGHT);
var _92c=false;
var _92d=this.caret_;
if(this.caret_on_word_){
this.caret_on_word_=false;
this.caret_=this.on_which_word_.clone();
this.caret_.go_next();
this.on_which_word_=null;
}else{
if((!_92b)&&(this.caret_.is_xlit())){
this.caret_on_word_=true;
this.on_which_word_=this.caret_;
}else{
if(!this.caret_.is_end()){
this.caret_=this.caret_.clone();
this.caret_.go_next();
}
}
}
if(_92b){
this.add_selection_highlight_();
}
if(_92d.equals(this.caret_)){
_92c=true;
}
this.update_on_move(_92c);
};
this.cursor_to_home=function(_92e){
var rect=_92e.get_rect();
var c=_92e.clone();
_92e=c.clone();
while(!c.is_line_begin()){
c.go_previous();
var _931=c.get_rect();
if(_931.right()>rect.left()){
break;
}
rect=_931;
_92e=c.clone();
}
return _92e;
};
this.cursor_to_end=function(_932){
var rect=_932.get_rect();
var c=_932.clone();
_932=c.clone();
while(!c.is_line_end()){
c.go_next();
var _935=c.get_rect();
if(_935.left()<rect.right()){
break;
}
rect=_935;
_932=c.clone();
}
return _932;
};
this.move_home=function(_936){
var _937=false;
var _938=this.caret_;
this.prepare_before_move_(_936,this.MOVING_LEFT);
this.caret_on_word_=false;
this.on_which_word_=null;
this.caret_=this.cursor_to_home(this.caret_);
if(_936){
this.add_selection_highlight_();
}
if(_938.equals(this.caret_)){
_937=true;
}
this.update_on_move(_937);
};
this.move_end=function(_939){
var _93a=false;
var _93b=this.caret_;
this.prepare_before_move_(_939,this.MOVING_RIGHT);
this.caret_on_word_=false;
this.on_which_word_=null;
this.caret_=this.cursor_to_end(this.caret_);
if(_939){
this.add_selection_highlight_();
}
if(_93b.equals(this.caret_)){
_93a=true;
}
this.update_on_move(_93a);
};
this.move_up=function(_93c){
var _93d=false;
var _93e=this.caret_;
if(this.popup_.visible_){
var item=this.on_which_word_.item();
var _940=item.index();
var _941=item.options().length;
if(_941>this.popup_.max_options_){
_941=this.popup_.max_options_;
}
_940=(_940-1)%(_941);
if(_940<0){
_940=_941-1;
}
item.choose_option(_940);
this.popup_.update(item);
return;
}
this.prepare_before_move_(_93c,this.MOVING_LEFT);
this.caret_on_word_=false;
this.on_which_word_=null;
var prev=this.cursor_to_home(this.caret_);
if(!prev.is_begin()){
prev.go_previous();
var _943=this.cursor_to_home(prev);
var rect=this.caret_.get_rect();
var x=rect.left();
var y=(rect.top()+rect.bottom())/2;
this.caret_=this.get_nearest_cursor_in_range(_943,prev,x,y);
}else{
this.caret_=prev;
}
if(_93c){
this.add_selection_highlight_();
}
if(_93e.equals(this.caret_)){
_93d=true;
}
this.update_on_move(_93d);
};
this.move_down=function(_947){
var _948=false;
var _949=this.caret_;
if(this.popup_.visible_){
var item=this.on_which_word_.item();
var _94b=item.index();
var _94c=item.options().length;
if(_94c>this.popup_.max_options_){
_94c=this.popup_.max_options_;
}
_94b=(_94b+1)%(_94c);
item.choose_option(_94b);
this.popup_.update(item);
return;
}
this.prepare_before_move_(_947,this.MOVING_RIGHT);
this.caret_on_word_=false;
this.on_which_word_=null;
var next=this.cursor_to_end(this.caret_);
if(!next.is_end()){
next.go_next();
var _94e=this.cursor_to_end(next);
var rect=this.caret_.get_rect();
var x=rect.left();
var y=(rect.top()+rect.bottom())/2;
this.caret_=this.get_nearest_cursor_in_range(next,_94e,x,y);
}else{
this.caret_=next;
}
if(_947){
this.add_selection_highlight_();
}
if(_949.equals(this.caret_)){
_948=true;
}
this.update_on_move(_948);
};
this.select_all=function(){
if(this.caret_on_word_){
this.caret_on_word_=false;
this.on_which_word_=null;
}
if(this.anchor_!=null){
this.remove_selection_highlight_();
}
var _952=this.caret_.clone();
_952.go_begin();
var end=this.caret_.clone();
end.go_end();
this.caret_=end;
this.set_anchor(_952);
this.add_selection_highlight_();
this.update_on_move();
};
this.edit_function=function(func){
var _955=this.caret_;
var _956=this.caret_on_word_;
if(_956){
_955=this.on_which_word_;
}
var _957=[];
var _958=false;
if(this.anchor_){
this.remove_selection_highlight_();
var _959;
if(this.anchor_.lesser(this.caret_)){
_959=new QOpDelFragment(this.anchor_,this.caret_);
this.caret_=this.anchor_;
}else{
_959=new QOpDelFragment(this.caret_,this.anchor_);
}
_958=true;
this.anchor_=null;
this.caret_on_word_=false;
_957.push(_959.perform_and_invert(this.ctx_));
}
var edit={op:null,cursor:this.caret_,on_word:false,selection:_958};
Quill.lib.bind_this(this,func)(edit);
if(edit.op){
_957.push(edit.op.perform_and_invert(this.ctx_));
}
this.caret_=edit.cursor;
this.caret_on_word_=edit.on_word;
if(edit.on_word){
this.on_which_word_=edit.cursor;
}else{
this.on_which_word_=null;
}
refresh_get_rect();
this.update_on_move();
_957.reverse();
this.undo_list_.push({caret:_955,on_word:_956,op:new QOpGroup(_957)});
this.redo_list_=[];
this.update_textarea();
this.update_char_count();
};
this.key_delete=function(){
this.edit_function(function(edit){
if(edit.selection){
return;
}
if(this.caret_on_word_){
var _95c=this.on_which_word_;
var end=_95c.clone();
end.go_next();
edit.op=new QOpDelFragment(_95c,end);
}else{
if(!this.caret_.is_end()){
if(edit.cursor.is_xlit()){
edit.on_word=true;
}else{
var end=edit.cursor.clone();
end.go_next();
edit.op=new QOpDelFragment(edit.cursor,end);
}
}
}
});
};
this.key_backspace=function(){
var _95e=null;
this.edit_function(function(edit){
if(edit.selection){
return;
}
var line=this.caret_.line();
if(this.caret_on_word_){
var item=this.on_which_word_.item();
var _962=item.english();
Quill.lib.assert(_962.length>0);
_962=_962.substring(0,_962.length-1);
if(_962.length==0){
var _963=this.on_which_word_;
var end=_963.clone();
end.go_next();
edit.op=new QOpDelFragment(_963,end);
edit.cursor=_963;
_95e=this.get_new_item_attributes();
}else{
edit.op=new QOpChangeXlitItem(this.on_which_word_,_962,item.options(),item.index(),true);
edit.cursor=this.on_which_word_;
edit.on_word=true;
this.popup_enabled_=true;
}
}else{
if(this.caret_.is_line_begin()&&(line.type()==_7cb.BULLET)){
var _965=new QLineAttributes(_7cb.SIMPLE,line.level(),line.align());
edit.op=new QOpFormatLine(this.caret_.u,_965);
}else{
if(this.caret_.is_line_begin()&&(this.caret_.line().level()>0)){
var _965=new QLineAttributes(line.type(),line.level()-1,line.align());
edit.op=new QOpFormatLine(this.caret_.u,_965);
}else{
if(!this.caret_.is_begin()){
var end=this.caret_;
var _963=end.clone();
_963.go_previous();
edit.cursor=_963;
if(_963.is_xlit()){
edit.on_word=true;
}else{
edit.op=new QOpDelFragment(_963,end);
}
_95e=this.get_new_item_attributes();
}
}
}
}
});
if(_95e!=null){
this.set_transient_attributes(_95e);
}
};
this.key_enter=function(){
if(this.enter_callback_!=null){
this.enter_callback_();
return;
}
var _966=null;
this.edit_function(function(edit){
if(this.caret_on_word_){
this.caret_=this.on_which_word_.clone();
this.caret_.go_next();
this.on_which_word_=null;
this.caret_on_word_=false;
}
var _968=new QDFLine([],this.get_line_attributes());
var _969=new QDocFragment([],[_968]);
edit.op=new QOpAddFragment(this.caret_,_969);
edit.cursor=this.caret_.clone();
edit.cursor.u++;
edit.cursor.v=0;
_966=this.get_new_item_attributes();
});
this.set_transient_attributes(_966);
};
this.key_tab=function(){
this.edit_function(function(edit){
if(this.caret_on_word_){
edit.cursor=this.on_which_word_;
var item=this.on_which_word_.item();
var _96c=4;
if(item.options().length<5){
_96c=item.options().length;
}
edit.op=new QOpChangeXlitItem(edit.cursor,item.english(),item.options(),(item.index()+1)%_96c,item.is_updating());
edit.on_word=true;
this.popup_enabled_=true;
}
});
};
this.key_xlit_char=function(ch){
this.edit_function(function(edit){
var _96f=this.get_new_item_attributes();
if(this.caret_on_word_){
edit.cursor=this.on_which_word_;
edit.on_word=true;
var item=edit.cursor.item();
edit.op=new QOpChangeXlitItem(edit.cursor,item.english()+ch,item.options(),item.index(),true);
this.popup_enabled_=true;
}else{
if(_96f.lang=="english"){
var _971=new QDFText(ch,_96f);
var _972=new QDocFragment([_971],[]);
edit.op=new QOpAddFragment(this.caret_,_972);
edit.cursor=this.caret_.clone();
edit.cursor.v++;
}else{
var self=this;
function try_itrans_merge(){
var c=self.caret_.clone();
if(c.is_line_begin()){
return false;
}
c.go_previous();
if(c.is_line_begin()){
return false;
}
var _975=c.item();
if(!_975.is_QTextItem){
return false;
}
var s=_975.text();
if((s!=".")&&(s!="/")&&(s!="^")&&(s!="~")){
return false;
}
var xlit=c.previous_item();
if(!xlit.is_QXlitItem){
return false;
}
var _978=new QOpDelFragment(c,self.caret_);
c=c.clone();
c.go_previous();
edit.cursor=c;
edit.on_word=true;
var _979=new QOpChangeXlitItem(c,xlit.english()+s+ch,xlit.options(),xlit.index(),true);
edit.op=new QOpGroup([_978,_979]);
return true;
}
if(!try_itrans_merge()){
var _971=new QDFXlit(ch,_96f,[],0,true);
var _972=new QDocFragment([_971],[]);
edit.op=new QOpAddFragment(this.caret_,_972);
edit.cursor=this.caret_;
edit.on_word=true;
}
this.popup_enabled_=true;
}
}
if(this.on_started_typing_callback&&this.get_english_text()==""){
var that=this;
setTimeout(function(){
that.on_started_typing_callback();
},100);
}
});
};
this.key_space=function(ch){
this.key_simple_char(this.SPACE_CHAR);
};
this.key_simple_char=function(ch){
this.edit_function(function(edit){
if(this.caret_on_word_){
edit.cursor=this.on_which_word_.clone();
edit.cursor.go_next();
}
var _97e=new QDFText(ch,this.get_new_item_attributes());
var _97f=new QDocFragment([_97e],[]);
edit.op=new QOpAddFragment(edit.cursor,_97f);
edit.cursor=edit.cursor.clone();
edit.cursor.v++;
if(this.on_started_typing_callback&&this.get_english_text()==""){
var that=this;
setTimeout(function(){
that.on_started_typing_callback();
},100);
}
});
};
this.apply_item_format=function(func){
if(this.anchor_!=null){
var _982=this.caret_;
var c1=this.anchor_.clone();
var c2=this.caret_.clone();
if(c1.greater(c2)){
var temp=c1;
c1=c2;
c2=temp;
}
var _986=new QItemAttributes(null,null,null,null,null,null,null);
func(_986);
var ops=[];
while(c1.not_equals(c2)){
if(!c1.is_line_end()){
ops.push(new QOpFormatItem(c1.clone(),_986));
}
c1.go_next();
}
var op=new QOpGroup(ops);
var _989=op.perform_and_invert(this.ctx_);
refresh_get_rect();
this.update_on_move();
this.undo_list_.push({caret:_982,on_word:false,op:_989});
this.redo_list_=[];
}else{
if(this.caret_on_word_){
this.caret_on_word_=false;
this.caret_=this.on_which_word_.clone();
this.caret_.go_next();
this.on_which_word_=null;
}
var a=this.get_new_item_attributes();
func(a);
this.set_transient_attributes(a);
}
};
this.set_lang=function(lang){
this.apply_item_format(function(x){
x.set_lang(lang);
x.set_font_size(Quill.lib.font_size(lang).replace(/px/i,""));
});
};
this.set_font_name=function(name){
this.apply_item_format(function(x){
x.set_font_name(name);
});
};
this.set_font_size=function(size){
this.apply_item_format(function(x){
x.set_font_size(size);
});
};
this.set_bold=function(flag){
this.apply_item_format(function(x){
x.set_bold(flag);
});
};
this.set_italic=function(flag){
this.apply_item_format(function(x){
x.set_italic(flag);
});
};
this.set_underline=function(flag){
this.apply_item_format(function(x){
x.set_underline(flag);
});
};
this.set_color=function(_997){
this.apply_item_format(function(x){
x.set_color(_997);
});
};
this.set_bg_color=function(_999){
this.apply_item_format(function(x){
x.set_bg_color(_999);
});
};
this.end_color_change=function(){
if(this.anchor_!=null){
this.add_selection_highlight_();
}
};
this.apply_line_format=function(func){
var _99c=this.caret_;
var _99d=this.caret_on_word_;
if(_99d){
_99c=this.on_which_word_;
}
var u1=this.caret_.u;
var u2=u1;
if(this.anchor_!=null){
u2=this.anchor_.u;
}
if(u1>u2){
var temp=u1;
u1=u2;
u2=temp;
}
var ops=[];
for(var i=u1;i<=u2;++i){
var a=this.doc_.line(i).get_attributes();
func(a);
var op=new QOpFormatLine(i,a);
ops.push(op);
}
var op=new QOpGroup(ops);
var _9a5=op.perform_and_invert(this.ctx_);
refresh_get_rect();
this.update_on_move();
this.undo_list_.push({caret:_99c,on_word:_99d,op:_9a5});
this.redo_list_=[];
};
this.set_align=function(_9a6){
this.apply_line_format(function(a){
a.align=_9a6;
});
};
this.listify=function(){
this.apply_line_format(function(a){
a.type=_7cb.BULLET;
});
};
this.unlistify=function(){
this.apply_line_format(function(a){
a.type=_7cb.SIMPLE;
});
};
this.increase_indent=function(){
this.apply_line_format(function(a){
a.level+=1;
});
};
this.decrease_indent=function(){
this.apply_line_format(function(a){
if(a.level>0){
a.level-=1;
}
});
};
this.can_undo=function(){
return this.undo_list_.length>0;
};
this.undo=function(){
if(this.undo_list_.length==0){
return;
}
if(this.anchor_){
this.remove_selection_highlight_();
this.anchor_=null;
}
var _9ac=this.caret_;
var _9ad=this.caret_on_word_;
if(_9ad){
_9ac=this.on_which_word_;
}
var obj=this.undo_list_.pop();
var _9af=obj.op.perform_and_invert(this.ctx_);
this.caret_=obj.caret;
this.caret_on_word_=obj.on_word;
if(obj.on_word){
this.on_which_word_=obj.caret;
}else{
this.on_which_word_=null;
}
refresh_get_rect();
this.update_on_move();
this.redo_list_.push({caret:_9ac,on_word:_9ad,op:_9af});
};
this.can_redo=function(){
return this.redo_list_.length>0;
};
this.redo=function(){
if(this.redo_list_.length==0){
return;
}
if(this.anchor_){
this.remove_selection_highlight_();
this.anchor_=null;
}
var _9b0=this.caret_;
var _9b1=this.caret_on_word_;
if(_9b1){
_9b0=this.on_which_word_;
}
var obj=this.redo_list_.pop();
var _9b3=obj.op.perform_and_invert(this.ctx_);
this.caret_=obj.caret;
this.caret_on_word_=obj.on_word;
if(obj.on_word){
this.on_which_word_=obj.caret;
}else{
this.on_which_word_=null;
}
refresh_get_rect();
this.update_on_move();
this.undo_list_.push({caret:_9b0,on_word:_9b1,op:_9b3});
};
this.make_doc_fragment=function(_9b4,_9b5){
function copy_items_(_9b6,_9b7,i,j){
var _9ba=j-i;
for(;_9ba>0;--_9ba){
var item=_9b7.item(i);
_9b6.push(item_to_df_(item));
i++;
}
}
function copy_items_till_line_end_(_9bc,_9bd){
var line=_9bd.line();
var end=_9bd.clone();
end.go_line_end();
copy_items_(_9bc,line,_9bd.v,end.v);
}
var _9c0=new QDocFragment([],[]);
var c=_9b4.clone();
var _9c2=_9b5.u-c.u;
if(_9c2==0){
copy_items_(_9c0.initial,c.line(),c.v,_9b5.v);
}else{
copy_items_till_line_end_(_9c0.initial,c);
c.go_next_line();
for(;_9c2>0;--_9c2){
var line=c.line();
var _9c4=new QDFLine([],line.get_attributes());
_9c0.lines.push(_9c4);
if(_9c2>1){
copy_items_till_line_end_(_9c4.items,c);
}else{
copy_items_(_9c4.items,line,c.v,_9b5.v);
}
c.go_next_line();
}
}
return _9c0;
};
this.doc_fragment_to_text=function(_9c5,_9c6){
var _9c7=[];
function add_line(_9c8,_9c9){
var line=[];
for(var i=0;i<_9c8.length;++i){
var t;
if(_9c6&&_9c8[i].is_QDFXlit){
t=_9c8[i].get_english();
}else{
t=_9c8[i].get_text();
}
if(t==this.SPACE_CHAR){
t=" ";
}
line.push(t);
}
var s=line.join("");
if(_9c9){
s="- "+s;
}
_9c7.push(s);
}
add_line(_9c5.initial,false);
for(var i=0;i<_9c5.lines.length;++i){
var line=_9c5.lines[i];
add_line(line.items,line.attr.type==_7cb.BULLET);
}
return _9c7.join("\n");
};
this.get_language_text=function(){
var _9d0=this.caret_.clone();
_9d0.go_begin();
var end=this.caret_.clone();
end.go_end();
var _9d2=this.make_doc_fragment(_9d0,end);
return this.doc_fragment_to_text(_9d2);
};
this.change_lang=function(lang){
var _9d4=this.lang_font_[lang.toLowerCase()];
if(!_9d4){
_9d4=lang;
lang="English";
}
this.set_lang(lang.toLowerCase());
this.set_font_name(_9d4);
this.init_lang_=lang.toLowerCase();
this.init_font_="Arial";
if(_9d4!="English"){
this.init_font_=_9d4;
}
};
this.set_char_limit=function(_9d5){
this.max_char_count=_9d5;
};
this.get_english_text=function(){
var _9d6=this.caret_.clone();
_9d6.go_begin();
var end=this.caret_.clone();
end.go_end();
var _9d8=this.make_doc_fragment(_9d6,end);
return this.doc_fragment_to_text(_9d8,true);
};
this.cut=function(c1,c2){
this.c1=c1;
this.c2=c2;
this.edit_function(function(edit){
});
};
this.internal_cut=function(){
if(this.anchor_==null){
return;
}
if($.browser.msie||Quill.lib.isMobile){
var _9dc=document.getElementById("paste");
}else{
var _9dc=this.window_.document.getElementById("paste");
}
_9dc.style.display="block";
if(this.anchor_.lesser(this.caret_)){
this.internal_clipboard=this.make_doc_fragment(this.anchor_,this.caret_);
this.cut(this.anchor_,this.caret_);
}else{
this.internal_clipboard=this.make_doc_fragment(this.caret_,this.anchor_);
this.cut(this.caret_,this.anchor_);
}
_9dc.value=this.doc_fragment_to_text(this.internal_clipboard);
this.external_clipboard=_9dc.value;
_9dc.focus();
_9dc.select();
var that=this;
var _9de=function(){
_9dc.style.display="none";
that.grab_focus();
};
setTimeout(_9de,0);
};
this.paste=function(){
if($.browser.msie||Quill.lib.isMobile){
var _9df=document.getElementById("paste");
}else{
var _9df=this.window_.document.getElementById("paste");
}
_9df.style.display="block";
_9df.style.top=this.caret_.get_rect().top();
_9df.focus();
_9df.value="";
var _9e0=this.external_clipboard;
var that=this;
var _9e2=function(){
if((jQuery.trim(_9df.value)==jQuery.trim(that.external_clipboard)||(_9df.value.length==0&&that.external_clipboard.length>0))&&that.internal_clipboard){
that.internal_paste();
that.grab_focus();
}else{
var _9e3="";
if(that.max_char_count>-1){
var _9e4=that.max_char_count-that.char_count;
_9e3=_9df.value.substr(0,_9e4);
}else{
_9e3=_9df.value;
}
that.external_paste(_9e3,Quill.Config.client.disableOnPasteTransliterate);
that.grab_focus();
}
_9df.value="";
_9df.style.display="none";
};
setTimeout(_9e2,0);
};
this.internal_paste=function(){
this.edit_function(function(edit){
if(this.caret_on_word_){
edit.cursor=this.on_which_word_.clone();
edit.cursor.go_next();
}
edit.op=new QOpAddFragment(edit.cursor,this.internal_clipboard);
edit.cursor=edit.op.get_ending_cursor(this.ctx_);
});
};
this.external_paste=function(str,_9e7){
this.edit_function(function(edit){
if(this.caret_on_word_){
this.caret_=this.on_which_word_.clone();
this.caret_.go_next();
this.on_which_word_=null;
this.caret_on_word_=false;
}
var _9e9=new QDocFragment([],[]);
var _9ea=true;
var _9eb;
var _9ec=new QLineAttributes(_7cb.SIMPLE,0,_7cc.LEFT);
var _9ed=this.get_new_item_attributes();
var _9ee=str.split("\n");
this.word="";
this.xlit_word="";
this.move_items_=function(_9ef,word,_9f1,_9f2){
if(_9f2){
_9ef.push(new QDFText(word,_9f1));
}else{
if(_9f1.lang=="english"){
for(var k=0;k<word.length;k++){
_9ef.push(new QDFText(word.charAt(k),_9f1));
}
}else{
_9ef.push(new QDFXlit(word,_9f1,[],0,true));
}
}
};
this.is_alpha=function(ch){
var _9f5=ch.charCodeAt(0);
if((_9f5>=97&&_9f5<97+26)||(_9f5>=65&&_9f5<65+26)){
return true;
}
return false;
};
this.is_special=function(ch){
var _9f7=ch.charCodeAt(0);
if(!this.is_alpha(ch)&&_9f7>=32&&_9f7<=126){
return true;
}
return false;
};
this.is_utf=function(ch){
if(!this.is_alpha(ch)&&!this.is_special(ch)){
return true;
}
return false;
};
this.push_word=function(wd){
if(wd=="xlit"&&this.xlit_word.length>0){
this.move_items_(_9fa,this.xlit_word,_9ed,true);
this.xlit_word="";
}
if(wd=="word"&&this.word.length>0){
this.move_items_(_9fa,this.word,_9ed,false);
this.word="";
}
};
for(var j=0;j<_9ee.length;j++){
var _9fa=_9e9.initial;
if(j>0){
_9eb=new QDFLine([],_9ec);
_9e9.lines.push(_9eb);
_9fa=_9eb.items;
}
for(var i=0;i<_9ee[j].length;++i){
if(!_9e7&&this.is_alpha(_9ee[j].charAt(i))){
this.push_word("xlit");
this.word+=_9ee[j].charAt(i);
}else{
if(this.is_utf(_9ee[j].charAt(i))){
this.push_word("word");
this.xlit_word+=_9ee[j].charAt(i);
}else{
this.push_word("xlit");
this.push_word("word");
if(_9ee[j].charAt(i)==" "){
this.move_items_(_9fa,this.SPACE_CHAR,_9ed,true);
}else{
this.move_items_(_9fa,_9ee[j].charAt(i),_9ed,true);
}
}
}
}
this.push_word("xlit");
this.push_word("word");
}
edit.op=new QOpAddFragment(this.caret_,_9e9);
edit.cursor=edit.op.get_ending_cursor(this.ctx_);
});
};
this.internal_copy=function(){
var sel;
if(this.anchor_==null){
return;
}
if($.browser.msie||Quill.lib.isMobile){
var _9fe=document.getElementById("paste");
}else{
var _9fe=this.window_.document.getElementById("paste");
}
_9fe.style.display="block";
if(this.anchor_.lesser(this.caret_)){
this.internal_clipboard=this.make_doc_fragment(this.anchor_,this.caret_);
}else{
this.internal_clipboard=this.make_doc_fragment(this.caret_,this.anchor_);
}
_9fe.value=this.doc_fragment_to_text(this.internal_clipboard);
this.external_clipboard=_9fe.value;
_9fe.focus();
_9fe.select();
if($.browser.msie){
document.execCommand("Copy");
}
var that=this;
var _a00=function(){
_9fe.style.display="none";
that.grab_focus();
};
setTimeout(_a00,0);
};
this.update_char_count=function(){
var text=this.get_language_text();
this.char_count=text.length;
if(typeof (this.char_count_span)!="undefined"){
$(this.char_count_span).text(this.char_count);
}
};
this.save=function(val){
var _a03="http://quillpad.in/hindi/backend2/";
var ifra=document.getElementById("saveiFrame");
var _a05=ifra.contentDocument?ifra.contentDocument:ifra.contentWindow.document;
var _a06=this.ctx_.root.innerHTML;
var _a07=_a05.getElementById("data");
var _a08=_a05.getElementById("filename");
if(val=="text"){
_a07.value=this.get_language_text();
_a03=_a03+"save_as_text";
}else{
if(val=="html"){
_a07.value=_a06;
_a03=_a03+"save";
}
}
_a08.value="Untitled";
var _a09=_a05.getElementById("saveForm");
_a09.action=_a03;
_a09.submit();
};
this.clear_doc=function(){
this.select_all();
if(this.anchor_.lesser(this.caret_)){
this.internal_clipboard=this.make_doc_fragment(this.anchor_,this.caret_);
this.cut(this.anchor_,this.caret_);
}else{
this.internal_clipboard=this.make_doc_fragment(this.caret_,this.anchor_);
this.cut(this.caret_,this.anchor_);
}
this.undo_list_=[];
this.redo_list_=[];
this.internal_clipboard;
this.external_clipboard="";
this.transient_attributes_=null;
this.anchor_=null;
this.caret_=new QCursor(this.doc_,0,0);
this.caret_on_word_=false;
this.on_which_word_=null;
};
this.get_scroll=function(axis){
win=this.window_;
doc=this.ctx_.html_doc;
ie_doc=this.window_;
var _a0b=0;
function non_ie(axis){
var _a0d=0;
if(typeof (win.pageYOffset)=="number"){
_a0d=(axis=="HORIZONTAL")?win.pageYOffset:win.pageXOffset;
}else{
if(doc.body&&(doc.body.scrollLeft||doc.body.scrollTop)){
_a0d=(axis=="HORIZONTAL")?doc.body.scrollLeft:doc.body.scrollTop;
}else{
if(doc.documentElement&&(doc.documentElement.scrollLeft||doc.documentElement.scrollTop)){
_a0d=(axis=="HORIZONTAL")?doc.documentElement.scrollLeft:doc.documentElement.scrollTop;
}
}
}
return _a0d;
}
function ie(axis){
var _a0f=0;
if(ie_doc&&(ie_doc.scrollTop||ie_doc.scrollLeft)){
_a0f=(axis=="HORIZONTAL")?ie_doc.scrollLeft:ie_doc.scrollTop;
}else{
if(ie_doc.documentElement&&(ie_doc.documentElement.scrollLeft||ie_doc.documentElement.scrollTop)){
_a0f=(axis=="HORIZONTAL")?ie_doc.documentElement.scrollLeft:doc.documentElement.scrollTop;
}
}
return _a0f;
}
return ($.browser.msie||Quill.lib.isMobile)?ie(axis):non_ie(axis);
};
this.set_prefill_text=function(text,lang){
this.edit_function(function(edit){
this.has_prefill_text=true;
var c=this.caret_.clone();
var line=[];
var _a15=text.split(" ");
for(i=0;i<_a15.length;++i){
var word=_a15[i];
var _a17=new QItemAttributes(lang,Quill.Config.fonts[lang],"11",false,false,false,"#888888","#FFFFFF");
if(i!=0){
line.push(new QDFText(this.SPACE_CHAR,_a17));
}
if(lang=="english"){
for(var k=0;k<word.length;k++){
line.push(new QDFText(word.charAt(k),_a17));
}
}else{
line.push(new QDFXlit(word,_a17,[word],0,false));
}
}
var qdoc=new QDocFragment(line,[]);
edit.op=new QOpAddFragment(this.caret_,qdoc);
});
};
this.on_request=function(_a1a){
var that=this;
var _a1c=Quill.Config.client.maxWaitTime?Quill.Config.client.maxWaitTime:5;
_a1c=_a1c*1000;
this.waiting_request["request_"+_a1a]=window.setTimeout(function(){
that.on_request_timeout();
},_a1c);
};
this.on_request_timeout=function(){
var _a1d=this.inscript_mode;
this.timedOutRequest++;
if(Quill.Config.client.maxFailedRequest&&Quill.Config.client.netFailureMessage&&Quill.Config.client.netFailureStyle&&this.timedOutRequest>Quill.Config.client.maxFailedRequest){
if(!this.statusMessage&&!_a1d){
var id=this.ctx_.root.id.replace(/_div$/,"");
var ele=$("#"+id);
var _a20=$(ele).outerWidth();
var _a21=$(ele).outerHeight();
var _a22=$(ele).offset();
var _a23=$("<div style="+Quill.Config.client.netFailureStyle+" ></div>",ele.ownerDocument);
$(_a23).text(Quill.Config.client.netFailureMessage);
if($.browser.msie&&$.browser.version=="6.0"){
$(_a23).css("top","0");
}
$(ele).after(_a23);
this.statusMessage=_a23;
}
}
};
this.on_response=function(_a24){
if(this.waiting_request["request_"+_a24]){
window.clearTimeout(this.waiting_request["request_"+_a24]);
}
this.timedOutRequest=0;
if(this.statusMessage){
$(this.statusMessage).remove();
}
this.statusMessage=null;
};
this.init_(_8b4,root,_8b6,win,_8b9,_8ba,_8bb);
}
Quill.enable=function(idx,item){
if((typeof (idx)=="undefined")){
return;
}
if(!item){
item=$("#"+idx);
}
if(!item){
return;
}
var _a27=$(item).attr("qlang");
var _a28=null;
if(_a27){
langs=_a27.replace(/\s/g,"").split(/,/);
_a28=langs[0];
}
var uid=$(item).attr("id");
if(!uid){
uid=Quill.lib.unique_id(document,"Quill");
$(item).attr({id:uid});
}
Quill.init(uid,_a28);
};
Quill.convert_all=function(){
function enable(idx,item){
if($(item).attr("quillpad")!=="true"||$(item).css("display")=="none"){
return;
}
Quill.enable(idx,item);
}
$("textarea").each(enable);
$("input").each(function(idx,item){
if($(item).attr("type")==="text"){
enable(idx,item);
}
});
};
Quill.convert_all();
$(document).ready(function(){
Quill.convert_all();
});
})();
})(jQuery);

