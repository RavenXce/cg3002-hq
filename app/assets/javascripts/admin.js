jQuery(function($) {
  $('textarea.autosize-transition').autosize();
  $('#reset-inv-add').on('click', function() {
  	$('#form-field-inv-add').val("").trigger('autosize.resize');	
  });
});