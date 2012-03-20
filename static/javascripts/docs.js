head.js("/javascripts/search-data.js", function() {
  
	$("input#search").show().autocomplete({
		autoFocus: false,
		source: function(req, res) { window.search_index(req.term, res); },
		minLength: 2,
		select: function( event, ui ) {
			$(this).attr("disabled", true);
			document.location = ui.item.url;
			return false;
		},
		focus: function( event, ui ) {
			$(this).val( ui.item.title );
			return false;
		}
	}).data("autocomplete")._renderItem = function( ul, item ) {
			return $( "<li></li>" )
				.data( "item.autocomplete", item )
				.append( "<a>" + item.title + "</a>" )
				.appendTo( ul );
		};
});

function disqus_config() {
     this.callbacks.onReady = [function() {
         var bb_comment_count = $('#dsq-num-posts').text();

         if (bb_comment_count == 1) {
           $('#post_metadata li.comment_count a').text(bb_comment_count + ' comment');
          }
          else if (bb_comment_count > 1) {
            $('#post_metadata li.comment_count a').text(bb_comment_count + ' comments');
          }
          else {
            $('#post_metadata li.comment_count a').text('Leave a comment');
          }
         }];
};

head.js("http://brightbox.disqus.com/embed.js");
