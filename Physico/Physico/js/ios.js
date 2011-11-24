

GUI.IOS= {
    init: function()    {
        document.addEventListener( 'touchcancel', GUI.IOS.sendEvents['cancel'], false);
        document.addEventListener( 'touchstart', GUI.IOS.sendEvents['start'], false);
        document.addEventListener( 'touchmove', GUI.IOS.sendEvents['move'], false);
        document.addEventListener( 'touchend', GUI.IOS.sendEvents['end'], false);
    },
    sendEvents: {
        "start": function(e) {
        GUI.IOS.sendEvent("startTouch", "");        
        },
        "cancel": function(e) {
        },
        "move": function(e) {
        e.preventDefault();
        },
        "end": function(e) {
        GUI.IOS.sendEvent("endTouch", "");
        },
    },
    sendEvent: function(event, data)  {    
        var iframe = document.createElement("IFRAME");
        iframe.setAttribute("src", "call:triggerEvent:"+event+":"+data);
        document.documentElement.appendChild(iframe);
        iframe.parentNode.removeChild(iframe);
        iframe = null;
    }
}