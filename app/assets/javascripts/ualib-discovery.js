$(document).ready(function () {
 	$('.btn-xsmall').click(function(){ //you can give id or class name here for $('button')
    	$(this).text(function(i,old){
        	return old=='more' ?  'less' : 'more';
    	});
	});
});