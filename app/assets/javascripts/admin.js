/*
 *= require jquery.js
 *= require jquery-ui.js
 *= require jquery.ui.datepicker-ru.js
 */

function preload_images(images) {
  $("<div />")
    .addClass("images_preload")
    .appendTo("body")
    .css({
      "position": "absolute",
      "bottom": 0,
      "left": 0,
      "visibility": "hidden",
      "z-index": -9999
    });
  $.each(images, function(index, value) {
    $("<img src=\"" + value + "\" />").appendTo($(".images_preload"));
  });
};

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

function nested_form() {
  $('a.add_nested_fields').live('click', function() {
    // Setup
    var assoc   = $(this).attr('data-association');            // Name of child
    var content = $('#' + assoc + '_fields_blueprint').html(); // Fields template

    // Make the context correct by replacing new_<parents> with the generated ID
    // of each of the parent objects
    var context = ($(this).closest('.fields').find('input:first').attr('name') || '').replace(new RegExp('\[[a-z]+\]$'), '');

    // context will be something like this for a brand new form:
    // project[tasks_attributes][new_1255929127459][assignments_attributes][new_1255929128105]
    // or for an edit form:
    // project[tasks_attributes][0][assignments_attributes][1]
    if(context) {
      var parent_names = context.match(/[a-z_]+_attributes/g) || [];
      var parent_ids   = context.match(/(new_)?[0-9]+/g) || [];

      for(var i = 0; i < parent_names.length; i++) {
        if(parent_ids[i]) {
          content = content.replace(new RegExp('(_' + parent_names[i] + ')_.+?_', 'g'), '$1_' + parent_ids[i] + '_');
          content = content.replace(new RegExp('(\\[' + parent_names[i] + '\\])\\[.+?\\]', 'g'), '$1[' + parent_ids[i] + ']');
        }
      }
    }

    // Make a unique ID for the new child
    var regexp  = new RegExp('new_' + assoc, 'g');
    var new_id  = new Date().getTime();
    content     = content.replace(regexp, "new_" + new_id);

    var field = $(content).insertBefore(this);
    $(this).closest("form").trigger({type: 'nested:fieldAdded', field: field});
    if ($(this).hasClass("address")) {
      $(this).hide();
    };
    return false;
  });

  $('a.remove_nested_fields').live('click', function() {
    var hidden_field = $(this).prev('input[type=hidden]')[0];
    if(hidden_field) {
      hidden_field.value = '1';
    }
    $(this).closest('.fields').hide();
    $(this).closest("form").trigger('nested:fieldRemoved');
    if ($(this).hasClass("address")) {
      $(this).closest('.fields').next().show();
    };
    return false;
  });
};

$(function() {
  init_datepicker();
  nested_form();

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

  $(".sort_link").click(function() {
    var it_off = $(this).hasClass("off"),
        url = $(this).attr("href"),
        parent_block = $(this).parent().parent();
    if (it_off) {
      $(this).removeClass("off").addClass("on");
      $(".sortable span", parent_block).css("display", "inline-block");
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
      $(".sortable span", parent_block).hide();
      $(this).removeClass("on").addClass("off");
    };
    return false;
  });
});
