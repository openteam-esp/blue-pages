//= require active_admin/base
//= require jquery
//= require jquery-ui


function serializeSubdivisions(){
  var subdivisionIds = $.makeArray(
      $("#sortable .subdivision").map(function(){
        return $(this).data("id");
      })
      );
  var csrf_token = $('head meta[name="csrf-token"]').attr('content');
  return { "ids" : subdivisionIds,
           "authenticity_token" : csrf_token };
};

$(function(){
  $('#sortable').sortable({
    update: function(){
              $.ajax({
                url: "/admin/subdivisions/sort",
              type: 'post',
              data: serializeSubdivisions(),
              complete: function(){
                $(".paginated_collection").effect("highlight");
              }
              });
            }
  });
});
