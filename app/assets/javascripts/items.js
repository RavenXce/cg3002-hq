$(document).on('ready page:load', function() {
	var allProductsTable = $('#all-items-table').dataTable({
		sPaginationType : "bootstrap",
		bJQueryUI : false,
		bProcessing : true,
		bServerSide : true,
		sAjaxSource : $('#all-items-table').data('source'),
		aoColumnDefs : [{
			"bSortable" : false,
			"aTargets" : [0, 7]
		}, {
			"sClass" : "hidden-480",
			"aTargets" : [3, 4]
		}, {
			"sWidth" : "25%",
			"aTargets" : [2]
		}, {
			"sWidth" : "100px",
			"aTargets" : [7]
		}],
		aaSorting : [[6, 'desc']],
		"fnRowCallback" : function(nRow, aData) {
			$(nRow).data('id', aData[8]);
		},
		fnDrawCallback : function() {// Injection to modify DOM
			$('.dataTables_actions').html('<a href="#modal-form-add-item" data-rel="tooltip" data-toggle="modal" title="Add a new product"><i class="icon-plus-sign purple bigger-130"></i></a>' + '<a href="#" data-rel="tooltip" title="Batch update products"><i class="icon-pencil blue bigger-130"></i></a>' + '<a href="#" id="add-shop-items-btn" data-rel="tooltip" title="Add products to stores"><i class="icon-zoom-in grey bigger-130"></i></a>' + '<a href="#" class="tooltip-error" data-rel="tooltip" title="Batch removal"><i class="icon-trash red bigger-130"></i></a>');
			$('[data-rel=tooltip]').tooltip();
			$('.edit-item').on(ace.click_event, function() {
				$('#modal-form-edit-item').load('/products/' + $(this).parents('tr').data('id') + '/edit');
			});
			$('.delete-item').on(ace.click_event, function(e) {
				e.preventDefault();
				$row = $(this).parents('tr');
				bootbox.dialog({
					message : "<span class='bigger-110'>Really delete forever?</span>",
					buttons : {
						"delete" : {
							"label" : "Delete!",
							"className" : "btn-sm btn-danger",
							"callback" : function() {
								$.ajax({
									type : 'DELETE',
									url : 'products/' + $row.data('id'),
									data : {
										authenticity_token : AUTH_TOKEN
									},
									success : function(result) {
										allProductsTable.fnDraw();
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
			$('#add-all-stores-btn').on('change', function(){
				$(this).prop('checked') ? $('#form-group-tags').hide() : $('#form-group-tags').show();
			});
			$('#add-shop-items-btn').on(ace.click_event, function(e) {
				e.preventDefault();
				var dialog = $("#dialog-message").removeClass('hide').dialog({
					modal : true,
					width : "400px",
					title : '<div class="widget-header widget-header-small"><h4 class="smaller"><i class="icon-ok"></i> Store selection </h4></div>',
					title_html : true,
					buttons : [{
						text : "Cancel",
						"class" : "btn btn-xs",
						click : function() {
							$(this).dialog("close");
						}
					}, {
						text : "OK",
						"class" : "btn btn-primary btn-xs",
						click : function() {
							$(this).dialog("close");
							$form = $('#form-batch-add');
							item_ids = [];
							$('#all-items-table').find('tr:gt(0)').each(function(){
								$this = $(this);
								if ($this.find('td:first-child input:checkbox').prop('checked') === true) {
									item_ids.push($this.data('id'));
								}								
							});
							$form.find('#item_ids').val(item_ids.join(', '));
							$form.submit();
						}
					}]
				});
			});
		}
	});

	$('#item-file-input').ace_file_input({
		style : 'well',
		btn_choose : 'Drop item data files here for batch add/update',
		btn_change : null,
		no_icon : 'icon-cloud-upload',
		droppable : true,
		thumbnail : 'small'
	});

	//we could just set the data-provide="tag" of the element inside HTML, but IE8 fails!
	var $tag_input = $('#form-field-shop-id-tags');
	if (!( /msie\s*(8|7|6)/.test(navigator.userAgent.toLowerCase()))) {
		$tag_input.tag({
			placeholder : $tag_input.attr('placeholder'),
			//enable typeahead by specifying the source array
			source : ace.variable_US_STATES,//defined in ace.js >> ace.enable_search_ahead
		});
	} else {
		//display a textarea for old IE, because it doesn't support this plugin or another one I tried!
		$tag_input.after('<textarea id="' + $tag_input.attr('id') + '" name="' + $tag_input.attr('name') + '" rows="3">' + $tag_input.val() + '</textarea>').remove();
		//$('#form-field-tags').autosize({append: "\n"});
	}
});
