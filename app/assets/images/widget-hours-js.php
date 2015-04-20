
var hourswidget = "";


hourswidget = '<div class="hours-widget"><p><strong><span class="open">Open</span> until 9PM</strong></p></div>';


if (typeof jQuery != 'undefined') {  


document.write(hourswidget);

jQuery('.hours-widget').css('margin', '10px 0');
jQuery('.hours-widget .open, .hours-widget .closed').css({ 'font-variant' : 'small-caps', 'font-size' : '120%' });


} else {

document.write(hourswidget);

}//closes if-else
