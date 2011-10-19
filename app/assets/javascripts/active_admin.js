//= require active_admin/base
//= require jquery
//= require jquery-ui


function serializeSubdivisions() {
  var subdivisionIds = $.makeArray(
    $("#sortable .subdivision").map(function() {
      return $(this).data("id");
    })
  );
  var csrf_token = $('head meta[name="csrf-token"]').attr('content');
  return {
    "ids": subdivisionIds,
    "authenticity_token" : csrf_token
  };
};

$(function() {

  $('.sort_link').click(function() {
    var it_off = $(this).hasClass('off');
    if (it_off) {
      $(this).removeClass('off').addClass('on');
      $('#sortable span').css('display', 'inline-block');
      $('#sortable').sortable({
        axis: 'y',
        handle: 'span',
        update: function() {
          var block = this;
          $.ajax({
            url: "/admin/subdivisions/sort",
            type: 'post',
            data: serializeSubdivisions(),
            success: function(data, textStatus, jqXHR) {
              $(block).effect("highlight");
            },
            error: function(jqXHR, textStatus, errorThrown) {
              console.log(jqXHR.responseText);
              $("<div />").attr("id", "ajax_error").appendTo("body").hide()
                .html(jqXHR.responseText);
              $("#ajax_error meta").remove();
              $("#ajax_error style").remove();
              $("#ajax_error").dialog({
                title: errorThrown,
                width: "70%",
                height: 500,
                modal: true,
                resizable: false
              });
            }
          });
        }
      });
    } else {
      $(this).removeClass('on').addClass('off');
      $('#sortable span').hide();
    };
    return false;
  });

});
