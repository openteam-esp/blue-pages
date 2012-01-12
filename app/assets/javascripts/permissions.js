$(function(){
  $('.show_permissions').click(function(){
    $('.permission_list').slideUp();
    $(this).parent().next('.permission_list').slideDown();
  });
});
