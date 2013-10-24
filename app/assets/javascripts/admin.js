jQuery(function($) {
	$('#reset-inv-add').on('click', function() {
		$('#form-field-inv-add').val("").trigger('autosize.resize');
	});
});
$(document).on('page:load', function() {
	$('textarea.autosize-transition').autosize();
});