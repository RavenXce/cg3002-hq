$(document).on('ready  page:load', function() {
	$(".chosen-select").chosen({
		width : '80%'
	});
	$('#delivery-timepicker').timepicker({
		minuteStep : 1,
		showSeconds : false,
		showMeridian : false,
		defaultTime : '00:00AM'
	}).next().on(ace.click_event, function() {
		$(this).prev().focus();
	});
	$('#shop-file-input').ace_file_input({
		style : 'well',
		btn_choose : 'Drop shop data files here or click to choose',
		btn_change : null,
		no_icon : 'icon-cloud-upload',
		droppable : true,
		thumbnail : 'small'//large | fit
		//, icon_remove:null//set null, to hide remove/reset button
		/**,before_change:function(files, dropped) {
		 //Check an example below
		 //or examples/file-upload.html
		 return true;
		 }*/
		/**,before_remove : function() {
		 return true;
		 }*/
		,
		preview_error : function(filename, error_code) {
			//name of the file that failed
			//error_code values
			//1 = 'FILE_LOAD_FAILED',
			//2 = 'IMAGE_LOAD_FAILED',
			//3 = 'THUMBNAIL_FAILED'
			//alert(error_code);
		}
	}).on('change', function() {
		//console.log($(this).data('ace_input_files'));
		//console.log($(this).data('ace_input_method'));
	});
	$('.delete-shop').on('click', function(e) {
		e.preventDefault();
		$table = $('#all-products-table');
		$row = $(this).parents('tr');
		$.ajax({
			type : 'POST',
			url : 'stores/delete',
			parameters : {
				s_id: $row.find('.s_id').val(),
				authenticity_token: AUTH_TOKEN
			},
			success : function(result) {
				$table.fnDeleteRow($row);
			},
			error : function(jqXHR, status, error) {
				alert('error!');
			}
		});
	});
});
