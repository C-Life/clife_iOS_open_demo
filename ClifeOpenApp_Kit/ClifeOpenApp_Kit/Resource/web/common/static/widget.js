!function(t,n){var e=n(t);"object"==typeof exports?module.exports=e:"function"==typeof t.define&&(define.amd||define.cmd)?define(["zepto"],function(t){return e}):t.Widget=t.Widget||e}(this,function(t){function n(){this._$elem=null,this.cfg={},this._handlers={}}return n.prototype={constructor:n,on:function(t,n){return this._handlers.hasOwnProperty(t)||(this._handlers[t]=[]),this._handlers[t].push(n),this},fire:function(t,n){if("[object Array]"==Object.prototype.toString.call(this._handlers[t]))for(var e=this._handlers[t],i=0,r=e.length;i<r;i++)e[i].apply(this,Array.prototype.slice.call(arguments,1));return this},eachBind:function(t){var n;if(t)for(key in t)t.hasOwnProperty(key)&&(n=t[key],"string"==typeof n&&"function"==typeof this.get(n)?this.on(key,this.get(n)):"function"==typeof n&&this.on(key,n))},set:function(t,n){return this.cfg[t]=n,this},get:function(t){return this.cfg[t]},isBind:function(t){var n=Object.prototype.toString.call(this._handlers[t]);return"[object Array]"==n&&0!=this._handlers[t].length},init:function(){},initCfg:function(){},renderUI:function(){},bindUI:function(){},syncUI:function(){},ready:function(){},render:function(t){this.init(),this.initCfg(t),this.renderUI(),this.bindUI(),this.syncUI();var n=$(this.get("target")||document.body);return this.get("isPrepend")?n.prepend(this._$elem):n.append(this._$elem),this.ready(),this},destroy:function(){this._$elem.off().remove(),this.fire("destroy")},find:function(t){return this._$elem.find(t)},getElem:function(){return this._$elem}},n});