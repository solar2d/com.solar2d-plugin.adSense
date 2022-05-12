

window.plugin_adSense_js ={

	size: function(width, height) {
		var coronaDisplay = document.getElementById("emscripten_border");
		var coronaCanvas = document.getElementById("canvas");
		this.coronaWidthConvertion = coronaCanvas.clientWidth/width;
		this.coronaHeightConvertion = coronaCanvas.clientHeight/height;
	},
	init: function(callback, params) {
		LuaReleaseFunction(this.callback);
		this.callback = null;
		if(LuaIsFunction(callback)) {
			this.callback = LuaCreateFunction(callback);
		}

		this.clientId = null;
		if(params && params.clientId){
			this.clientId = params.clientId;
		}
		else{
			alert("AdSense Plugin: client id not set .init()");
		}

		this.testMode = false;
		if(params && params.testMode){
			this.testMode = params.testMode;
		}

		if (this.init_internal) {
			this.init_internal();
			this.init_internal = null;
		}
	},

	init_internal: function()
	{
		var script = document.createElement('script');
		script.setAttribute('src', 'https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js?client='+this.clientId);
		script.setAttribute('crossorigin', 'anonymous');
		script.async = true;
		document.body.appendChild(script);



		script.onerror = function()
		{
			plugin_adSense_js.callback({ name:"adsRequest", provider:"adSense", phase: 'init', isError:true, error:"Network failure" });
		};

		script.onload = function()
		{
			plugin_adSense_js.callback({ name:"adsRequest", provider:"adSense", phase: 'init', isError:false});
		};


	},
	height:function() {
		if(this.ins){
			return parseInt(this.ins.style.height, 10)/this.coronaHeightConvertion;
		}
		return 0;
	},
	show: function(type,params) {
		//Remove old ad
		if(this.ins){
			this.ins.remove();
		}
		//Create ad
		this.ins = document.createElement('ins');
		this.ins.className = "adsbygoogle";
		this.ins.style.position = "absolute";
		this.ins.setAttribute('data-ad-slot', String(params.adSlot));
		this.ins.setAttribute('data-ad-client', this.clientId);
		document.body.appendChild(this.ins);
		//this.ins.setAttribute('data-ad-format', "auto");
		//this.ins.setAttribute('data-full-width-responsive', "true");

		//Center Ad
		this.ins.style.marginRight = "auto";
		this.ins.style.marginLeft = "auto";
		this.ins.style.left = "-4px";

		//Ajust size and position
		var coronaDisplay = document.getElementById("emscripten_border");
		var coronaCanvas = document.getElementById("canvas");
		if(params == null){
			params = {};
		}
		if(params.height == null){
			params.height = 100;
		}
		if(params.width){
			this.ins.style.width = params.width+"px";
		}else{
			this.ins.style.width = "100%";
		}
		this.ins.style.height = params.height+"px";
		if(params.position === "bottom"){
			this.ins.style.bottom = "0px";
		}else{
			this.ins.style.top = "-4px";
		}




		//push ads
		var script = document.createElement('script');
		var code = '(adsbygoogle = window.adsbygoogle || []).push({});';
		script.appendChild(document.createTextNode(code));
    document.body.appendChild(script);
		this.callback({ name:"adsRequest", provider:"adSense", phase: 'displayed' });

	},
	hide: function() {
		if(this.ins){
			this.ins.remove();
			this.callback({ name:"adsRequest", provider:"adSense", phase: 'hidden' });
		}
	},
};
