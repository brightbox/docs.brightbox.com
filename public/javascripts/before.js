var disqus_developer = 1;

function disqus_config() {
     this.callbacks.onReady = [function() {
         var bb_comment_count = $('#dsq-num-posts').text();
         
         //alert(bb_comment_count);
         
         if (bb_comment_count == 1) {
           $('#post_metadata li.comment_count a').text(bb_comment_count + ' comment');
          }
          else if (bb_comment_count > 1) {
            $('#post_metadata li.comment_count a').text(bb_comment_count + ' comments');
          }
          else {
            $('#post_metadata li.comment_count a').text('Leave a comment');
          }

         // $('#post_metadata li.comment_count a').fadeIn();

         }];
}

function update_countdown_to_launch () {
  $().countdown_to_launch();
  setTimeout("update_countdown_to_launch()", 1000);
}

head.ready(function() {
  //alert("ready!");

  // Zebra stripes for tables
  $("#main tr:nth-child(even)").addClass("even");

  $('a.zoom').fancyZoom({directory: '/images/fancyzoom'});

  // Smooth scroll for on-page links
  $('a[href^="#"]').smoothScroll({

    afterScroll: function(opts) {
      // highlight the target element if the link is .highlight
      if ($(this).hasClass("highlight")) {
        // hack to get around Jquery removing background images on highlight
        var bgi = $(opts.scrollTarget).css('backgroundImage');
        $(opts.scrollTarget).effect("highlight",{},1500);
        $(opts.scrollTarget).css('backgroundImage',bgi);
      }
    }
  });
  
  $("#twitterwidget").getTwitter({
    userName: "brightbox",
    numTweets: 5,
    loaderText: "Loading tweets...",
    slideIn: true,
    showHeading: false,
    headingText: "Latest Tweets",
    showProfileLink: false
  });

  $(".tip").tipTip({delay:50,defaultPosition:"top"});

  $("input#search").show().autocomplete({
    autoFocus: true,
    source: function( req, response ) {
      $.getJSON( "/searchindex.json", req, function( data, status, xhr ) {
        var text;
        response($(data).filter(function(i,e) {
          if (e.label == null || e.value == null) {
            return false;
          }
          text = e.label + ' ' + e.value;
          return text.match(new RegExp(req.term, "i"));
        }));
      });
    },
    minLength: 0,
    select: function( event, ui ) {
      $(this).attr("disabled", true);
      document.location = ui.item.value;
      return false;
    }
  });

  if ($("#launch").length > 0) {
    update_countdown_to_launch()
  };

});