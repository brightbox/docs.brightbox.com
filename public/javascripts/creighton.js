/*
 * MyFonts Webfont Build ID 116112, 2010-10-19T18:46:34-0400
 * 
 * The fonts listed in this notice are subject to the End User License
 * Agreement(s) entered into by the website owner. All other parties are 
 * explicitly restricted from using the Licensed Webfonts(s).
 * 
 * You may obtain a valid license at the urls below.
 * 
 * Webfont: Creighton
 * Url: http://new.myfonts.com/fonts/redrooster/creighton/regular/
 * Foundry: Red Rooster Collection
 * Copyright: Copyright (c) 2009 by International TypeFounders, Inc. All rights reserved.
 * License: http://www.myfonts.com/viewlicense?1056
 * Licensed pageviews: 10,000/month
 * CSS font-family: Creighton
 * CSS font-weight: normal
 * 
 * (c) 2010 Bitstream, Inc
*/



var scripts = document.getElementsByTagName("SCRIPT");
var script = scripts[scripts.length-1].src;
var path = script.replace(/\\/g,'/').replace(/\/[^\/]*\/?$/, '');

// safari 3.1: data-css
// firefox 3.6+: woff
// firefox 3.5+: data-css
// chrome 4+: data-css
// IE 5+: eot
// opera 10.1+: data-css
// mobile safari: svg

//document.write(navigator.userAgent);
var browserName, browserVersion, webfontType;

var webfontTypeOverride;

if (/webfont=(woff|ttf|eot)/.test(window.location.search))
{
	webfontTypeOverride = RegExp.$1;

	if (webfontTypeOverride == 'ttf')
		webfontTypeOverride = 'data-css';
}

if (/MSIE (\d+\.\d+)/.test(navigator.userAgent))
{
	browserName = 'MSIE';
	browserVersion = new Number(RegExp.$1);
	if (browserVersion >= 9.0)
		webfontType = 'woff';
	else if (browserVersion >= 5.0)
		webfontType = 'eot';
}

else if (/Firefox[\/\s](\d+\.\d+)/.test(navigator.userAgent))
{
	browserName = 'Firefox';
	browserVersion = new Number(RegExp.$1);
	if (browserVersion >= 3.5 && browserVersion < 3.6)
		webfontType = 'data-css';
	else if (browserVersion >= 3.6)
		webfontType = 'woff';
}

else if (/Chrome\/(\d+\.\d+)/.test(navigator.userAgent)) // must check before safari
{
	browserName = 'Chrome';
	browserVersion = new Number(RegExp.$1);

	if (browserVersion >= 6.0)
		webfontType = 'woff';

	else if (browserVersion >= 4.0)
		webfontType = 'data-css';
}

else if (/Mozilla.*(iPhone|iPad).*AppleWebKit.*Safari/.test(navigator.userAgent))
{
	browserName = 'MobileSafari';
	webfontType = 'svg';
}

else if (/Safari\/(\d+\.\d+)/.test(navigator.userAgent))
{
	browserName = 'Safari';
	if (/Version\/(\d+\.\d+)/.test(navigator.userAgent))
	{
		browserVersion = new Number(RegExp.$1);
		if (browserVersion >= 3.1)
			webfontType = 'data-css';
	}
}

else if (/Opera\/(\d+\.\d+)/.test(navigator.userAgent))
{
	browserName = 'Opera';
	if (/Version\/(\d+\.\d+)/.test(navigator.userAgent))
	{
		browserVersion = new Number(RegExp.$1);
		if (browserVersion >= 10.1)
			webfontType = 'data-css';
	}
}

if (!webfontType)
{
	// use flash?
}

if (webfontTypeOverride)
	webfontType = webfontTypeOverride;

switch (webfontType)
{
		case 'eot':
		document.write("<style>\n");
				document.write("@font-face {font-family:\"Creighton\";src:url(\"" + path + "/webfonts/eot/style_173487.eot\");}\n");
				document.write("</style>");
		break;
		
		case 'woff':
		document.write("<style>\n");
				document.write("@font-face {font-family:\"Creighton\";src:url(\"" + path + "/webfonts/woff/style_173487.woff\") format(\"woff\");}\n");
				document.write("</style>");
		break;
	
		case 'data-css':
		document.write("<link rel='stylesheet' type='text/css' href='" + path + "/webfonts/datacss/MyFonts Webfonts Order M2471422.css'>");
		break;
	
		
	default:
		webfontType = 'default';
		break;
}

//document.write(browserName + ' ' + browserVersion + ': ' + webfontType + ' [' + navigator.userAgent + ']');