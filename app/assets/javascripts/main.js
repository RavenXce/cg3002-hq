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
	if ( typeof PAGE_ERRORS != 'undefined') {
		$.gritter.add({
			title : 'Error',
			text : PAGE_ERRORS + ".",
			sticky: true,
			class_name : 'gritter-error'
		});
	}
});
