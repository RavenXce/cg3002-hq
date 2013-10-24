$(document).on('ready  page:load', function() {
	var allShopsTable = $('#all-shops-table').dataTable();
	$('.edit-shop').on(ace.click_event, function() {
		$('#modal-form-edit').load('/stores/'+$(this).parents('tr').data('id')+'/edit');
	});
	$(".chosen-select").chosen({
		width : '90%'
	});
	$('.delivery-timepicker').timepicker({
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
		//,    icon_remove:null//set null, to hide remove/reset button
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
	$('.delete-shop').on(ace.click_event, function(e) {
		e.preventDefault();
		$row = $(this).parents('tr');
		$spinner = $row.find('i.icon-spinner');
		bootbox.dialog({
			message : "<span class='bigger-110'>Really delete forever?</span>",
			buttons : {
				"delete" : {
					"label" : "Delete!",
					"className" : "btn-sm btn-danger",
					"callback" : function() {
						$spinner.removeClass('hidden');
						$.ajax({
							type : 'DELETE',
							url : 'stores/' + $row.data('id'),
							data : {
								authenticity_token : AUTH_TOKEN
							},
							success : function(result) {
								$spinner.addClass('hidden');
								console.log($('#all-shops-table').children().index($row));
								allShopsTable.fnDeleteRow($('#all-shops-table').children().index($row)); // XXX: get proper index!
							},
							error : function(jqXHR, status, error) {
							}
						});
					}
				},				
				"button" : {
					"label" : "Cancel",
					"className" : "btn-sm"
				}
			}
		});
	});
});
