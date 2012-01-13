//= require jquery.noisy.min

$(function(){

  $('body').noisy({
        'intensity' : 1,
      'size' : 200,
      'opacity' : 0.08,
      'fallback' : '',
      'monochrome' : false
  }).css('background-color', '#EDEBDE');

  $('.show_permissions').click(function(){
    var $this = $(this);
    var this_permission_list = $this.parent().next('.permission_list');

    $('.permission_list').not(this_permission_list).slideUp();
    $('.show_permissions').not($this).removeClass('arrowup active').addClass('arrowdown').text('Показать права доступа');

    this_permission_list.slideToggle('slow',function(){
      if ($(this).is(':visible')) {
        $this.removeClass('arrowdown').addClass('arrowup active').text('Скрыть права доступа');
      }else{
        $this.removeClass('arrowup active').addClass('arrowdown').text('Показать права доступа');
      };
    });
  });
});
