$(document).on('ready page:load', function() {
	$(".numeric-only").ForceNumericOnly();
	$('.chosen-select').each(function(){
		$(this).chosen({
			width : $('.chosen-select').data('width')
		});
	});
	$('table th input:checkbox').on('click', function() {
		var that = this;
		$(this).closest('table').find('tr > td:first-child input:checkbox').each(function() {
			this.checked = that.checked;
			$(this).closest('tr').toggleClass('selected');
		});
	});
	$.widget("ui.dialog", $.extend({}, $.ui.dialog.prototype, {
		_title: function(title) {
			var $title = this.options.title || '&nbsp;';
			if( ("title_html" in this.options) && this.options.title_html == true )
				title.html($title);
			else title.text($title);
		}
	}));
	if ( typeof PAGE_ERRORS != 'undefined') {
		$.gritter.add({
			title : 'Error',
			text : PAGE_ERRORS + ".",
			sticky: true,
			class_name : 'gritter-error'
		});
	}
	if ( typeof PAGE_MESSAGES != 'undefined') {
		$.gritter.add({
			title : 'Status',
			text : PAGE_MESSAGES + ".",
			sticky: false,
			class_name : 'gritter-success'
		});
	}
	if ( typeof PAGE_WARNINGS != 'undefined') {
		$.gritter.add({
			title : 'Warning',
			text : PAGE_WARNINGS + ".",
			sticky: false,
			class_name : 'gritter-warning'
		});
	}
});
