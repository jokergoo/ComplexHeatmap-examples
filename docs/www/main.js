
function open_page(link) {

	// create a new div
	var mask = document.createElement("div");
	mask.setAttribute("style", "position:absolute;top:0;right:0;bottom:0;left:0;background-color:rgba(0, 0, 0, 0.5);overflow-y: auto;z-index:2000;");
	mask.setAttribute("id", "example-mask");
	$(document.body).append(mask);

	var frame = document.createElement("div");
	frame.setAttribute("style", "position:relative;top:30;bottom:30;left:300;width:800;background-color:white;min-height:500px;");
	frame.setAttribute("id", "example-frame");
	$("#example-mask").append(frame);
	$("#example-frame").html("loading example...");

	var close = document.createElement("div");
	close.setAttribute("id", "example-close");
	close.setAttribute("style", "position:absolute;top:35;left:305;z-index:2010;");
	$("#example-mask").append(close);
	$("#example-close").html("<i class='fa fa-times'></i>");
	
	$('#example-close').click(function() {
		$('#example-mask').remove();
	});

	$('#example-mask').click(function(e) {
		var offset = $("#example-frame").offset();
		var x1 = offset.left;
		var y1 = offset.top;
		var x2 = offset.left + $("#example-frame").width();
		var y2 = offset.top + $("#example-frame").height();

		var x0 = e.pageX;
		var y0 = e.pageY;

		if(!(x0 >= x1 && x0 <= x2 && y0 >= y1 && y0 <= y2)) {
			$('#example-mask').remove();
		}
	});

	$.ajax({
		url: link,
		success: function(result) {
			$('#example-frame').html("<div style='margin:auto;padding:20 40;'></div>");
			result = result.replace('<p><a href="../../index.html">&larr; Go back to the main page</a></p>', "");
			url = link;
			result = "<p>Permanent link: <a href='" + url + "'>" + link + "</a></p>\n<hr>\n" + result;
			$('#example-frame div').html(result);
		}
	})
}
