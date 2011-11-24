GUI = {
	init: function(callback)    {
		this.sw = document.createElement('div')
		this.sw.className = "switch"
		this.swc = document.createElement('span')
		this.swc.innerHTML = "MENU"
		this.sw.appendChild(this.swc)
		this.sw.onclick = GUI.toggleActiveState
		document.body.appendChild(this.sw)
		this.itooltip = document.createElement('div')
		this.itooltip.className = 'itooltip'
		this.itooltip.innerHTML = "Physico"
		document.body.appendChild(this.itooltip)
		this.icredits = document.createElement('div')
		this.icredits.className = 'icredits'
		this.icredits.innerHTML = "(c) CornLabs 2011"
		document.body.appendChild(this.icredits)
		document.onkeydown = GUI.inactiveKeyHandler
		document.onkeyup = GUI.inactiveKeyUpHandler
        if (typeof(GUI.IOS) != "undefined") GUI.IOS.init();
		callback()
	},
	toggleActiveState: function()   {
			if (GUI.active)    GUI.deactivateGUI()
			else GUI.activateGUI();
	},
	activateGUI: function() {
		GUI.addClass(document.body, "GUI-active")
		this.swc.innerHTML = ""
        this.swc.style.padding = 0
		setTimeout("GUI.activateGUIP2()", 10)

		this.hdr = document.createElement('header')
		this.hdr.innerHTML = "Physico"
		document.body.appendChild(this.hdr)
		this.hdrc = document.createElement("aside")
		this.hdr.appendChild(this.hdrc)

		this.ct = document.createElement("section")
		this.ct.onclick = function(e)  {
			if (GUI.mnc)   {
				GUI.mnc = 0;
				return
			}
			GUI.toggleActiveState()
		}
		document.body.appendChild(this.ct)
		this.menu = GUI.createMenu(this.menuEntries)
		this.menu.onclick = function(e){
			GUI.mnc = 1;
		}
		this.ct.appendChild(this.menu)

		this.ftr = document.createElement("footer")
		this.ftr.innerHTML = " >> ";
		this.ftr.className = "red dark"
		document.body.appendChild(this.ftr)
		this.ftri = document.createElement("input")
		this.ftri.onkeydown = function(e) {
			k = e.keyCode || e.which;
			switch (k)  {
				case 13: GUI.cmdExec();break;
				case 38: GUI.getLastCMD();break;
				case 27: GUI.ftri.blur(); break;
			}
		};
		this.ftri.onmouseover = function(){ GUI.tip("This is a command-line prompt for Physico. Try to run some Javascript commands. You'd be surprized ^^") }
		this.ftri.onfocus = function() { GUI.ftrif = true;  }
		this.ftri.onblur = function() { GUI.ftrif = false; }
		this.ftri.style.width = window.innerWidth - 50 + "px";
		this.ftr.appendChild(this.ftri)
		this.ftrf = document.createElement("span")
		this.ftrf.onclick = GUI.toggleExecLog
		this.ftrf.onmouseover = function(){ GUI.tip("Toggle the command history log.") }
		this.ftr.appendChild(this.ftrf)
		this.ftrl = document.createElement("aside")
		this.ftrl.className = "white dark"
		this.ftrl.onmouseover = function(){ GUI.tip("The log of your previous commands.") }
		this.ftr.appendChild(this.ftrl)
		this.hdrc.onmouseover = function(){ GUI.tip("Select your poison! <span class='red dark'>A tooltip will appear here to let you know what you're doing</span>")}
		this.hdrc.innerHTML = "Select your poison! <span class='red dark'>A tooltip will appear here to let you know what you're doing</span>"

		document.onkeydown = GUI.activeKeyHandler
		document.onkeyup = GUI.inactiveKeyUpHandler

		this.active = 1
		console.log("GUI Activated")
	},
	activateGUIP2: function()   {
		GUI.addClass(this.hdr, "active")
		GUI.addClass(this.hdrc, "active")
		GUI.addClass(this.ct, "active")
		GUI.addClass(this.ftr, "active")
	},
	deactivateGUI: function()   {
		GUI.removeClass(document.body, "GUI-active")
		document.body.removeChild(this.ct)
		document.body.removeChild(this.hdr)
		document.body.removeChild(this.ftr)
		GUI.swc.innerHTML = "MENU"
        GUI.swc.style.padding = "0 10px"
		GUI.active = 0;
		document.onkeydown = GUI.inactiveKeyHandler
		document.onkeyup = GUI.inactiveKeyUpHandler
		console.log("GUI Deactivated")
	},
	tip: function(text) {
		this.hdrc.innerHTML = text;
	},
	cmdExec: function()  {
		eval(this.ftri.value)
		this.ftrl.innerHTML += "<p>"+this.ftri.value+"</p>";
		this.ftrl.scrollTop = this.ftrl.scrollHeight;
		this.ftri.value = "";
	},
	getLastCMD: function(){
		h = this.ftrl.getElementsByTagName("p");
		if(!h.length) return
		h = h[h.length - 1];
		this.ftri.value = h.innerHTML;
	},
	toggleExecLog: function()   {
		if (GUI.ftrla)  {
			GUI.removeClass(GUI.ftrl, "active")
			GUI.removeClass(GUI.ftrf, "down")
			GUI.ftrla = 0;
			console.log("Log Down")
			return
		}
		GUI.addClass(GUI.ftrl, "active")
		GUI.addClass(GUI.ftrf, "down")
		GUI.ftrla = 1;
		console.log("Log Up")
	},
	addClass: function(to, cl) {
		to.className += " " + cl;
	},
	removeClass: function(to, cl)    {
		to.className = to.className.substr(0, to.className.indexOf(cl))
	},
	inactiveKeyHandler: function(e){
		switch(e.keyCode)   {
			case 17:
				Physico.rotationChange = 1;
				break;
			case 33:
				Physico.scene[2] -= 1;
				break;
			case 34:
				Physico.scene[2] += 1;
				break;
			case 37:
				if (Physico.rotationChange) Physico.rotate[1]-= Math.PI / 100
				else Physico.scene[0] -= 1;
				break;
			case 38:
				if (Physico.rotationChange) Physico.rotate[0]+= Math.PI / 100
				else Physico.scene[1] += 1;
				break;
			case 39:
				if (Physico.rotationChange) Physico.rotate[1]+= Math.PI / 100
				else Physico.scene[0] += 1;
				break;
			case 40:
				if (Physico.rotationChange) Physico.rotate[0]-= Math.PI / 100
				else Physico.scene[1] -= 1;
				break;
			case 46:
				Physico.scene = [0, 0, -15]
                Physico.rotate = [0, 0, 0]
				break;
			case 77:
				GUI.toggleActiveState()
				break;
		}
	},
	inactiveKeyUpHandler: function(e){
		switch(e.keyCode)	{
			case 17:
				Physico.rotationChange = 0
		}
	},
	activeKeyHandler: function(e)   {
		k = e.keyCode || e.which
		if (GUI.ftrif) return
		switch(k)   {
			case 76: GUI.toggleExecLog();
			case 67: GUI.ftri.focus(); break;
			case 77: GUI.toggleActiveState(); break;
		}
	},
    activeKeyUpHandler: function(e) {

    },
	hdr: null,
	sw: null,
	ct: null,
	menu: null,
	mnc: 0,
	hdrc: null,
	ftr: null,
	ftri: null,
	ftrif: false,
	ftrl: null,
	ftrf: null,
	ftrla: null,
	itoolitp: null,
	active: 0,
	windows: [],
	menuEntries: {
		"Objects :" : {
			"Add one Object" : function() { Physico.ObjectList.addObject() },
			"Add 100 Objects" : function() { Physico.ObjectList.addObjects(100) },
			"Add 1000 Objects" : function() { Physico.ObjectList.addObjects(1000) },
			"Remove one Object" : function() { Physico.ObjectList.removeObject() },
			"Remove 100 Objects" : function() { Physico.ObjectList.removeObjects(100) },
			"Remove 1000 Objects" : function() { Physico.ObjectList.removeObjects(1000) },
			"Scramble Objects" : function() { Physico.ObjectList.scrambleObjects() }
		},
		"Forces :" : {
			"Gravity" : function() { Physico.Animator.ToggleEnvForce("gravity") },
			"Wind" : function() { Physico.Animator.ToggleEnvForce("wind") },
			"Inverse Gravity" : function() { Physico.Animator.ToggleEnvForce("repulse") },
			"Inverse Wind" : function() { Physico.Animator.ToggleEnvForce("inverse-wind") }
		}
	},
	createMenu: function(object)  {
		var r = document.createElement("ul")
		console.log(object)

		for(o in object)    {
			var e = document.createElement("li")
			switch (typeof(object[o])) {
				case "function" :
					var a = document.createElement("a")
					a.onclick = object[o];
					a.innerHTML = o;
					e.appendChild(a)
				break
				default:
					e.innerHTML = "<a>"+o+"</a>"
					var a = GUI.createMenu(object[o])
					e.appendChild(a);
			}
			r.appendChild(e)
		}
		return r;

	}
}
