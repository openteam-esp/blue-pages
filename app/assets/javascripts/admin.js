/*
 *= require jquery.js
 *= require jquery-ui.js
 *= require jquery.ui.datepicker-ru.js
 *= require jquery_ujs.js
 *= require nested_form.js
 */

function init_datepicker() {
  if ($.fn.datepicker) {
    $("form input.date").datepicker({
      changeMonth: true,
      changeYear: true,
      yearRange: "c-60:c+60",
      showOn: "button",
      showOtherMonths: true
    });
  };
};

function serializeBlock(parent_block) {
  var ids = $.makeArray(
    $(".sortable li", parent_block).map(function() {
      return $(this).data("id");
    })
  );
  var csrf_token = $("head meta[name=\"csrf-token\"]").attr("content");
  return {
    "ids": ids,
    "authenticity_token" : csrf_token
  };
};

function init_sort() {
  $(".sort_link").click(function() {
    var it_off = $(this).hasClass("off"),
        url = $(this).attr("href"),
        parent_block = $(this).parent().parent();
    if (it_off) {
      $(this).removeClass("off").addClass("on").addClass("invert");
      $(".sortable span", parent_block).removeClass("hidden").addClass("inline-block");
      $(".sortable", parent_block).sortable({
        axis: "y",
        handle: "span",
        update: function() {
          var block = this;
          $.ajax({
            url: url,
            type: "post",
            data: serializeBlock(parent_block),
            success: function(data, textStatus, jqXHR) {
              $(block).effect("highlight");
            },
            error: function(jqXHR, textStatus, errorThrown) {
              $("<div />")
                .attr("id", "ajax_error")
                .appendTo("body")
                .hide()
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
      $(".sortable span", parent_block).removeClass("inline-block").addClass("hidden");
      $(this).removeClass("on").addClass("off").removeClass("invert");
    };
    return false;
  });
};

$(function() {
  init_datepicker();
  init_sort();

  $(".phone_kind").live("change", function(){
    var phone_kind = $(this).val();
    var phone_code = $(this).closest("li").siblings("li[id*=\"code_input\"]");
    var phone_additional_number = $(this).closest("li").siblings("li[id*=\"additional_number_input\"]");
    if ((phone_kind == "internal") || (phone_kind == 'mobile')) {
      phone_code.slideUp("slow");
      phone_additional_number.slideUp("slow");
    } else {
      phone_code.slideDown("slow");
      phone_additional_number.slideDown("slow");
    };
  });
});
