$(function() {
  $('#mco_submit_multiple a').click(function(){
    if ($(this).hasClass('dropdown-toggle')) { return false }
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

original_toggle_actions = toggle_actions
function mco_toggle_actions() {
  original_toggle_actions();
  var dropdown = $("#mco_submit_multiple a");
  if ($.foremanSelectedHosts.length == 0) {
    dropdown.addClass("disabled hide");
    dropdown.attr('disabled', 'disabled');
  } else {
    dropdown.removeClass("disabled hide");
    dropdown.removeAttr('disabled');
  }
}
toggle_actions = mco_toggle_actions