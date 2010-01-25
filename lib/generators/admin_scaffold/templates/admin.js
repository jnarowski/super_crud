// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

// DROPDOWN MENUS

$(document).ready(function() { 
  initPage(); // usually only loaded once
  initObservers(); // might need to get loaded with ajax calls
}); 

function initPage() {
	
	$('a[rel*=facebox]').facebox() 
	
	// enable delayed observer forms
	if ( $(".observeForm").length > 0 ) {
		$('.observeForm').delayedObserver(0, function(element, value) {
			$.ajax({
				data:$(".observeForm :input").serialize(), 
				dataType:'script', 
				type:'post', 
				url: $('.observeForm').attr('action')
			});
		})
	}
	
	// ----------------------------------------------
	// outfit autocompletes
	// ----------------------------------------------

	$("#outfit_tag_list.autocomplete").autocomplete('/autocomplete/tags_for_outfit.js', 
	  { 
	    multiple: true,
	    multipleSeparator: ", " 
	  })				

	// ----------------------------------------------
	// top notice styling
	// ----------------------------------------------
	activateTopNotice();
	
}

function initObservers() {

	// ajaxed pagination
	$('div.pagination a').live("click", function(){  
	  $.ajax({
	    type: "POST",
	    url: $(this).attr('href'),
	    dataType: 'script',
	    success: function(js){
		    js;
				initObservers();
		  }
	  });
		return false;
	});
	
	// ----------------------------------------------
	// forms
	// ----------------------------------------------
	
	// ajaxed form
	$('.ajaxform').ajaxForm({
		dataType: 'script',		
    success: function(js){
	    js;
			initObservers();
	  }
	});

	// ajaxed link
	$('a.remote-link').live("click", function(){  
	  $.ajax({
	    type: "GET",
	    url: $(this).attr('href'),
	    dataType: 'script',
	    success: function(js){
		    js;
				initObservers();
		  }
	  });
		return false;
	});

  // ajaxed delete link
  $('a.remote-delete').live('click', function(event) {
    if ( confirm(this.title) )
      $.ajax({
        url: this.href.replace('/delete', ''),
        type: 'post',
        dataType: 'script',
        data: { '_method': 'delete' },
				success: function(js){
				  js;
				}
      });
			return false;
  });

	// ----------------------------------------------
	// Default Text
	// ----------------------------------------------
	
	// Add default text to inputs 
	// EG: <input title="Default Text Here" class="defaultText">
  $(".defaultText").focus(function(srcc) {
    if ($(this).val() == $(this)[0].title){ $(this).removeClass("defaultTextActive").val("") }
  });
  
  $(".defaultText").blur(function() {
    if ($(this).val() == ""){ $(this).addClass("defaultTextActive").val($(this)[0].title) }
  });
  $(".defaultText").blur();

	// ----------------------------------------------
	// Admin
	// ----------------------------------------------
	
	$('a.column-header').live("click", function(){  
	  $.ajax({
	    type: "POST",
	    url: $(this).attr('href'),
	    dataType: 'script',
	    success: function(js){
		    js;
				initObservers();
		  }
	  });
		return false;
	});
	
}

function activateTopNotice(slideupTime){
	time = (slideupTime ? slideupTime : 3000)
	if ( $("#top-notice").length > 0 ) {
		// allow the user to click the div to speed up the process
		$("#top-notice").click(function(){ $("#top-notice").slideUp("fast"); $("#top-notice").remove() })
		// slide the div down
		$("#top-notice").slideDown("slow");
		// if it hasn't been clicked yet slide it back up
		setTimeout(function() { $("#top-notice").slideUp("fast") }, time)
	}
}