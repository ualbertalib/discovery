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

 
   if ($("#chartContainer").length){
        var chart = new CanvasJS.Chart("chartContainer",
    {
      title:{
       text: "Comparison of Subjects"
      },
      axisX: {
        title:"Searches",
       maximum: 10000
      },
      axisY: {
        title:"Subjects"
      },

      legend:{
        verticalAlign: "bottom",
        horizontalAlign: "left"

      },
      data: [
      {
        type: "bubble",
        legendText: "Size of Bubble Represents Number of Something",
        showInLegend: true,
        legendMarkerType: "circle",
 toolTipContent: "<strong>{name}</strong> <br/> Subjects: {y}<br/> Searches: {x} yrs<br/> something: {z} mn",
     dataPoints: [
    // { x: 64.8, y: 2.66, z:12074.4 , name: "India"},
   //  { x: 73.1, y: 1.61, z:13313.8, name: "China"},
     { x: 6000, y: 2.00, z:30006.77, name: "US" },
     { x: 4000, y: 2.15, z: 23470.414, name: "Indonesia"},
     { x: 3250, y: 1.86, z: 19303.24, name: "Brazil"},
     { x: 6650, y: 2.36, z: 14002.24, name: "Mexico"},
     { x: 5009, y: 5.56, z: 15204.48, name: "Nigeria"},
     { x: 6806, y: 1.54, z:11401.91, name: "Russia" },
     { x: 2209, y: 1.37, z:11027.55, name: "Japan" },
     { x: 2908, y: 1.36, z:11810.90, name:"Australia" },
     { x: 5207, y: 2.78, z: 11790.71, name: "Egypt"},
     { x: 8001, y: 1.94, z:16190.81, name:"UK" },
     { x: 1508, y: 4.76, z: 11309.24, name: "Kenya"},
     { x: 8105, y: 1.93, z:11201.95, name:"Australia" },
     { x: 6801, y: 4.77, z: 13001.09, name: "Iraq"},
     { x: 4709, y: 6.42, z: 11330.42, name: "Afganistan"},
     { x: 5003, y: 5.58, z: 11048.55, name: "Angola"}
     ]
   }
   ]
 });

chart.render();
}
});


