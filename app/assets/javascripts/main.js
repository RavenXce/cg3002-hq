$(document).on('ready page:load', function() {
	$('table th input:checkbox').on('click', function() {
		var that = this;
		$(this).closest('table').find('tr > td:first-child input:checkbox').each(function() {
			this.checked = that.checked;
			$(this).closest('tr').toggleClass('selected');
		});

	});
	if (typeof PAGE_ERRORS != 'undefined') {
		$.gritter.add({
			title : 'Error',
			text : PAGE_ERRORS,
			class_name : 'gritter-error'
		});
	}
});
