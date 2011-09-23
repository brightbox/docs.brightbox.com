head.js("/javascripts/search-data.js", function() {
	$("input#search").show().autocomplete({
		autoFocus: true,
		source: function(req, res) { window.search_index(req.term, res); },
		minLength: 2,
		select: function( event, ui ) {
			$(this).attr("disabled", true);
			document.location = ui.item.url;
			return false;
		}
	}).data("autocomplete")._renderItem = function( ul, item ) {
			return $( "<li></li>" )
				.data( "item.autocomplete", item )
				.append( "<a>" + item.title + "</a>" )
				.appendTo( ul );
		};
});