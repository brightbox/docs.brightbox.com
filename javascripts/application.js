$(document).ready(function() {
	var lastXhr;
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
});