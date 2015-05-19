$(document).ready(function () {
  var offset;
  function setHeight() { //Set the scroll offset height depending on the height of the header
    offset = ($(".navbar-fixed-top").height()+15);
    if (offset>300) {
      offset=offset-120;
    }
    smoothScroll.init({
      speed: 60, // Integer. How fast to complete the scroll in milliseconds
      easing: 'easeInOutCubic', // Easing pattern to use
      updateURL: true, // Boolean. Whether or not to update the URL with the anchor hash on scroll
      offset: offset// Integer. How far to offset the scrolling anchor location in pixels
    });  
  };
  setHeight();
  $(window).resize(setHeight);
  
  $(document).on("scroll",function(){
    if($(document).scrollTop()>100){
      $("#main-nav").removeClass("large").addClass("small");
      $("#main-nav .col-sm-15").removeClass("col-sm-15 col-xs-15").addClass("col-sm-2");
      $("#home").show();
      $("#news-title").show();
    } else{
      $("#main-nav").removeClass("small").addClass("large");
      $("#main-nav .col-sm-2").removeClass("col-sm-2").addClass("col-sm-15 col-xs-15");
      $("#home").hide();
      $("#news-title").hide();
    }
    $('#news-pane').waypoint(function(direction) {
        $("#news>div").toggleClass('active', direction === 'down');
        }, {offset: 300});
    $('#services-pane').waypoint(function(direction){
        $("#services>div").toggleClass('active', direction === 'down');
        $("#news>div").removeClass('active', direction === 'down');
        }, {offset: 300});
    $('#subjects-pane').waypoint(function(direction) {
        $("#subjects>div").toggleClass('active', direction === 'down');
        $("#services>div").removeClass('active', direction === 'down');
        }, {offset: 300});
    $('#research-pane').waypoint(function(direction) {
        $("#research>div").toggleClass('active', direction === 'down');
        $("#subjects>div").removeClass('active', direction === 'down');
        }, {offset: 300});
    $('#account-pane').waypoint(function(direction) {
        $("#account>div").toggleClass('active', direction === 'down');
        $("#research>div").removeClass('active', direction === 'down');
        }, {offset:600});
  });
  $( ".selector" ).click(function() {
    $(".selector").removeClass("btn-blue");
    $(".selector").addClass("btn-ltblue");
    $(this).removeClass("btn-ltblue");
    $(this).addClass("btn-blue");
  });
  $( "#everything-limit" ).click(function() { 
    $('#main-search').attr('action', '/results');
    $('#q').attr('placeholder', 'search everything...');
  });
  $( "#shelves-limit" ).click(function() { 
    $('#main-search').attr('action', '/symphony');
    $('#q').attr('placeholder', 'search print books & journals...');
  });
  $( "#ebooks-limit" ).click(function() { 
    $('#main-search').attr('action', '/ebooks');
    $('#q').attr('placeholder', 'search ebooks...');
  });
  $( "#articles-limit" ).click(function() { 
    $('#main-search').attr('action', '/articles');
    $('#q').attr('placeholder', 'search articles...');
  });
  $( "#databases-limit" ).click(function() { 
    $('#main-search').attr('action', '/databases');
    $('#q').attr('placeholder', 'search databases...');
  });
  $( "#ejournals-limit" ).click(function() { 
    $('#main-search').attr('action', '/ejournals');
    $('#q').attr('placeholder', 'search ejournals...');
  });
   $( ".library-picker" ).html( getHoursLocationStatus(4) );
  $( ".hours-select" ).change(function () {
    var library = "";
    var location = "";
    $( "select option:selected" ).each(function() {
      library += $( this ).text() + " ";
      location = $(this).val();
    });
    imagestring ="https://www.library.ualberta.ca/2015assets/lib-icons/"+location+".png";
    $( ".library-picker" ).text(library);
    $( ".lib-pick img" ).attr( "src", imagestring);
    $( ".library-picker" ).html( getHoursLocationStatus(location) );
  })
 $(".news-square").hoverIntent(
    function() {
      $(this).find(".details").fadeIn(250);
    },    
    function() {
      $(this).find(".details").fadeOut(250);
  });
});


