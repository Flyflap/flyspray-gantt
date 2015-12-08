var pj,o,c,due,today;

var dsize='40'; // day width in pixel

function init(){

//	fstyle();
	cinit();
}
function verteilen(o){
	var i;
	n=o.children;
	for (i = 0, len = n.length; i < len; ++i) {
		n[i].style.width='auto';
		if(n[i].classList[0]=='group'){
			m=n[i].children;
			for (j = 0, tlen = m.length; j < tlen; ++j) {
				m[j].style.width='auto';
				if (o.classList[1]=='ami'){
					m[j].style.float='right';}
				else{
					m[j].style.float='left';
				}
				m[j].style.display='inline-block';
				m[j].style.verticalalign='top';
			}
		} else{
			if (o.classList[1]=='ami'){
				n[i].style.float='right';}
			else{
				n[i].style.float='left';
			}
		}
		n[i].style.display='inline-block';
		n[i].style.verticalalign='top';
	}
	//console.log(n);
	reconnect();
};
function ordnen(o){
	var i;
	n=o.children;
	for (i = 0, len = n.length; i < len; ++i) {
		n[i].style.float='none';
		n[i].style.display='inline-block';
		n[i].style.verticalalign='top';
		if(n[i].classList[0]=='group'){
			if(o.classList[1]=='ami'){
				n[i].style.width='202px';
			}else if(o.classList[1]=='ms'){
				n[i].style.width='232px';
			}
			m=n[i].children;
			for (j = 0, tlen = m.length; j < tlen; ++j) {
				 m[j].style.float='none';
				if(o.classList[1]=='ami'){
					m[j].style.width='200px';
				}else if(o.classList[1]=='ms'){
					m[j].style.width='230px';
				}
			}
		}else{
			if(o.classList[1]=='ami'){
				n[i].style.width='200px';
			}else if(o.classList[1]=='ms'){
				n[i].style.width='230px';
			}
		}
	}
	reconnect();
}


function unconnect(){
	context.clearRect(0, 0, canvas.width, canvas.height);
}
function reconnect(){
	context.clearRect(0, 0, canvas.width, canvas.height);
	canvas = document.getElementById('mycanvas');
	canvas.height=document.body.offsetHeight;
	canvas.width=document.body.offsetWidth;
	context = canvas.getContext('2d');
	context.lineWidth=1;
	//context.beginPath();

	// draw grid or at least some vertical timestamps. (constant timeframes or dynamic time stretches)
	// today and 
	context.beginPath();
	context.strokeStyle = "rgba(200,0,0,1)";
	xs=document.getElementById(c[0].tsrc).parentNode.offsetLeft;
	xe=xs;
	ys=10;
	ye=1000;
	context.moveTo(xs, ys);
	context.bezierCurveTo((xs+xe)/2, ys, (xs+xe)/2, ye, xe, ye);
        context.stroke();

	lw=document.getElementById('lines').clientWidth;
	hs=16;
	he=2;
	hm=8; // vert middle
	h=5;
	for (i = 0, len = c.length; i < len; ++i) {
		context.beginPath();
		if(c[i].trans=='inv'){
			context.strokeStyle = "rgba(200,0,0,1)";
		}else{
			context.strokeStyle = "rgba(0,127,0,1)";
		}
		if(document.getElementById(c[i].tsrc).checked){
			xs=document.getElementById(c[i].tsrc).offsetLeft + document.getElementById(c[i].tsrc).offsetWidth;
			ys=document.getElementById(c[i].tsrc+'.'+c[i].fsrc).offsetTop - document.getElementById(c[i].tsrc).parentNode.parentNode.scrollTop +hs;
		}else{
			//xs=document.getElementById(c[i].tsrc).offsetLeft + document.getElementById(c[i].tsrc).offsetWidth;
			// if css <td style="position:relative"...
			xs=document.getElementById(c[i].tsrc).offsetLeft + document.getElementById(c[i].tsrc).parentNode.offsetLeft + document.getElementById(c[i].tsrc).offsetWidth;
			//ys=document.getElementById(c[i].tsrc).offsetTop - document.getElementById(c[i].tsrc).parentNode.scrollTop+hs;
			ys=document.getElementById(c[i].tsrc).parentNode.offsetTop + document.getElementById(c[i].tsrc).offsetTop +hs;
		}

		if(document.getElementById(c[i].ttgt).checked){
			xe=document.getElementById(c[i].ttgt).parentNode.offsetLeft;
			if(document.getElementById(c[i].ttgt).parentNode.parentNode.classList[0]=='group'){
				ye=document.getElementById('jtl.'+c[i].ttgt+'.'+c[i].ftgt).offsetTop - document.getElementById(c[i].ttgt).parentNode.parentNode.parentNode.scrollTop +he;
			}else{
				ye=document.getElementById('jtl.'+c[i].ttgt+'.'+c[i].ftgt).offsetTop - document.getElementById(c[i].ttgt).parentNode.parentNode.scrollTop +he;
			}
		}else{
			//xe=document.getElementById(c[i].ttgt).offsetLeft;
			// if ccs <td style="position:relative"...
			xe=document.getElementById(c[i].tsrc).parentNode.offsetLeft + document.getElementById(c[i].ttgt).offsetLeft;
			if(document.getElementById(c[i].ttgt).parentNode.parentNode.classList[0]=='group'){
				ye=document.getElementById(c[i].ttgt).parentNode.offsetTop - document.getElementById(c[i].ttgt).parentNode.parentNode.parentNode.scrollTop +he;
				ye=document.getElementById(c[i].ttgt).parentNode.offsetTop - document.getElementById(c[i].ttgt).parentNode.parentNode.parentNode.scrollTop +he;
			}else{
				//ye=document.getElementById(c[i].ttgt).offsetTop - document.getElementById(c[i].ttgt).parentNode.scrollTop +he;
				ye=document.getElementById(c[i].ttgt).parentNode.offsetTop + document.getElementById(c[i].ttgt).offsetTop +he;
			}
		}
		context.moveTo(xs, ys);
		context.bezierCurveTo((xs+xe)/2, ys, (xs+xe)/2, ye, xe, ye);
		context.stroke();
	}

	for (i = 0, len = due.length; i < len; ++i) {
		context.beginPath();
		context.strokeStyle = "rgba(255,127,0,1)";
		context.lineWidth = 2;
		if(today>due[i].duetime){
			context.lineWidth = 16;
			context.strokeStyle = "rgba(255,0,0,1)";
			xs=document.getElementById(due[i].tsrc).parentNode.offsetLeft-10;
			xe=document.getElementById(due[i].tsrc).parentNode.offsetLeft;
			ys=document.getElementById(due[i].tsrc).parentNode.offsetTop - document.getElementById(due[i].tsrc).parentNode.scrollTop +8;
			ye=ys;
			context.moveTo(xs, ys);
			context.bezierCurveTo((xs+xe)/2, ys, (xs+xe)/2, ye, xe, ye);
		} else{
			//xs=document.getElementById(due[i].tsrc).parentNode.offsetLeft + document.getElementById(due[i].tsrc).offsetWidth;
			xs=document.getElementById(due[i].tsrc).parentNode.offsetLeft;
			//xe=document.getElementById(due[i].tsrc).parentNode.offsetLeft + document.getElementById(due[i].tsrc).offsetWidth+200;
			xe=document.getElementById(due[i].tsrc).parentNode.offsetLeft + ((due[i].duetime-today)/3600/24)*dsize;
			ys=document.getElementById(due[i].tsrc).parentNode.offsetTop - document.getElementById(due[i].tsrc).parentNode.scrollTop +4;
			ye=ys;
			context.moveTo(xs, ys);
			context.bezierCurveTo((xs+xe)/2, ys, (xs+xe)/2, ye, xe, ye);
			context.moveTo(xe,ye-4);
			context.lineTo(xe,ye+4);
		}
		context.stroke();

	}

};
function cinit(){
	canvas = document.getElementById('mycanvas');
	canvas.height=document.getElementById('tasklist_table').offsetHeight;
	canvas.width=document.getElementById('tasklist_table').offsetWidth;
	context = canvas.getContext('2d');

	window.addEventListener('resize', reconnect, false);
	window.addEventListener('click', reconnect, false);
	reconnect();
}
function fstyle(){
	for (i = 0, len = c.length; i < len; ++i) {
		document.getElementById(c[i].tsrc).parentNode.childNodes[1].style.backgroundColor='#9c6';
		document.getElementById(c[i].ttgt).parentNode.childNodes[1].style.backgroundColor='#9c6';
	}
}
