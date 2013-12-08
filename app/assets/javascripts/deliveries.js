$(document).on('ready page:load', function() {
	var allProductsTable = $('#all-deliveries-table').dataTable({
		sPaginationType : "bootstrap",
		bJQueryUI : false,
		bProcessing : true,
		bServerSide : true,
		sAjaxSource : $('#all-deliveries-table').data('source'),
		aoColumnDefs : [{
			"bSortable" : false,
			"aTargets" : [0, 7]
		}, {
			"sClass" : "hidden-480",
			"aTargets" : [3, 4, 6]
		}, {
			"sWidth" : "120px",
			"aTargets" : [2,6]
		}, {
			"sWidth" : "100px",
			"aTargets" : [7]
		}, {
			"sWidth" : "16%",
			"aTargets" : [4,5]
		},],
		aaSorting : [[6, 'desc']],
		"fnRowCallback" : function(nRow, aData) {
			$(nRow).data('id', aData[8]);
		},
		fnDrawCallback : function() {// Injection to modify DOM
			$('[data-rel=tooltip]').tooltip();
			$('.delete-delivery').on(ace.click_event, function(e) {
				e.preventDefault();
				$row = $(this).parents('tr');
				bootbox.dialog({
					message : "<span class='bigger-110'>Cancel this delivery?</span>",
					buttons : {
						"delete" : {
							"label" : "Delete!",
							"className" : "btn-sm btn-danger",
							"callback" : function() {
								$.ajax({
									type : 'DELETE',
									url : 'deliveries/' + $row.data('id'),
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
		}
	});
});
