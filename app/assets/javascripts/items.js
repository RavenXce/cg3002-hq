$(document).on('ready page:load', function() {
	$('#all-products-table').dataTable({
		sPaginationType : "bootstrap",
		bJQueryUI : false,
		bProcessing : true,
		bServerSide : true,
		sAjaxSource : $('#all-products-table').data('source'),
		aoColumnDefs: [
	      { "bSortable": false, "aTargets": [ 0, 7 ] },
	      { "sClass": "hidden-480", "aTargets": [ 3, 4 ] },
	      { "sClass": "hidden-480", "aTargets": [ 3, 4 ] },
	    ],
	    aaSorting: [[6,'asc']]
	});
}); 