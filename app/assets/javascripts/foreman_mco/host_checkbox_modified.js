function toggle_actions() {
  var dropdown = $("#submit_multiple a");
  dropdown.removeClass("disabled hide");
  dropdown.removeAttr('disabled');
}

// updates the form URL based on the action selection
$(function() {
  $('#submit_multiple a').click(function(){
    if (!$(this).hasClass('mco-action') && ($.foremanSelectedHosts.length == 0 || $(this).hasClass('dropdown-toggle'))) { return false }
    var title = $(this).attr('data-original-title');
    var url = $(this).attr('href') + "?" + $.param({host_ids: $.foremanSelectedHosts});
    $('#confirmation-modal .modal-header h3').text(title);
    $('#confirmation-modal .modal-body').empty().append("<img class='modal-loading' src='/assets/spinner.gif'>");
    $('#confirmation-modal').modal({show: "true", backdrop: "static"});
    $("#confirmation-modal .modal-body").load(url + " #content",
        function(response, status, xhr) {
          $("#loading").hide();
          $('#submit_multiple').val('');
          var b = $("#confirmation-modal .btn-primary");
          if ($(response).find('#content form select').size() > 0)
            b.addClass("disabled").attr("disabled", true);
          else
            b.removeClass("disabled").attr("disabled", false);
          });
    return false;
  });

  $('#confirmation-modal .btn-primary').click(function(){
    $("#confirmation-modal form").submit();
    $('#confirmation-modal').modal('hide');
  });

  $('#confirmation-modal .secondary').click(function(){
    $('#confirmation-modal').modal('hide');
  });
});
