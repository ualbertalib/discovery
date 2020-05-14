$(document).ready(function () {
  $('#sortAndPerPage .css-dropdown .btn ul, .articles-facets .facet_limit ul').css('display', 'none');
  $('#sortAndPerPage .css-dropdown .btn').click(function(){
    $(this).find('ul').toggle();
  });
  $('.facet_limit .twiddle').click(function(){
    $(this).parent().find('ul').toggle();
  });
});

function setiFrameAttr() {
    var myframes=document.getElementsByTagName("iframe");
    for(var i = 0; i < myframes.length; i++) {
      myframes[i].width = 'auto';
    }
}

window.onload=setiFrameAttr;

// Following function taken from blacklight/app/javascript/blacklight/facet_load.js of Blacklight 7 to get proper facet-count widths.
(function($) {
  'use strict';

  Blacklight.doResizeFacetLabelsAndCounts = function() {
    // adjust width of facet columns to fit their contents
    function longer (a,b){ return b.textContent.length - a.textContent.length; }

    $('ul.facet-values, ul.pivot-facet').each(function(){
      var longest = $(this).find('span.facet-count').sort(longer)[0];

      if (longest && longest.textContent) {
        var width = longest.textContent.length + 1 + 'ch';
        $(this).find('.facet-count').first().width(width);
      }
    });
  };

  Blacklight.onLoad(function() {
    Blacklight.doResizeFacetLabelsAndCounts();
  });
})(jQuery);

function getHathitrustLink(oclId) {
  $(document).ready(function () {
    $.ajax({
      url: 'http://catalog.hathitrust.org/api/volumes/brief/oclc/' + oclId + '.json&callback=hathitrustResponse',
      type: "GET",
      dataType: "jsonp",
      jsonpCallback: "hathitrustResponse"
    });
  });
}

function hathitrustResponse(json) {
  if (!jQuery.isEmptyObject(json) && !jQuery.isEmptyObject(json.records)) {

    // Proper response exists, show button and set hidden div text.
    $('#hathitrustButton').css('display', 'block');
    var recordURL = Object.values(json.records)[0].recordURL;

    var $hathitrust_link_div = $('#hathitrustLink');
    $hathitrust_link_div.text(recordURL + '?urlappend=%3Bsignon=swle:wayf');
  }
}

function hathitrustModal() {
  // Retrieve link and set form action.
  var $hathitrust_link_div = $('#hathitrustLink');

  var $hathitrust_form = $('#hathitrustForm');
  $hathitrust_form.attr('action', $hathitrust_link_div.text());

  $('#hathitrustForm').submit(function(e) {
    $('#ajax-modal').modal('hide');
  });
}
