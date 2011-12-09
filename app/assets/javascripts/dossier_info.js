function build_info_path(){
  var additional = $('.for_info_path').map(function(index, a){return $(a).val()}).get().join('/');
  var subdivision_id = $('.info_link').attr('data_subdivision');
  var info_path = $('#info_path');

  if (additional.length == 0) {
    return false
  };

  $.ajax({
    url: '/build_info_path',
    async: false,
    type: 'GET',
    data: {
      subdivision_id: subdivision_id,
      additional: additional
    },
    success: function(data){
      info_path.val(data);
    }
  });

  return info_path.val();
};

function encode_path_to_hash(path){
  var hash = '';
  $.ajax({
    url: '/build_info_path',
    async: false,
    type: 'GET',
    data: {
      encode: true,
      path_to_hash: path
    },
    success: function(data){
      hash = data;
    }
  });

  return hash;
};

function open_dialog(){
  $('.ajax_loading').remove();
  $('#info_ckeditor').dialog('open');
  $('body').css({ overflow: 'hidden' });
};

$(function(){
  var link        = $('.info_link');
  var choose_link = $('.choose_link');
  var info_path   = $('#info_path').val();
  var common_path = '/api/el_finder/v2?format=json';
  var target      = '';

  $('<div/>',{ class: 'info_wrapper', id: 'info_ckeditor'}).appendTo('body').dialog({
    autoOpen: false,
    draggable: false,
    height: 640,
    modal: true,
    position: 'center',
    resizable: false,
    title: 'Дополнительная информация (досье)',
    width: 840,
    beforeClose: function(event, ui) {
      $('body').css({overflow: 'inherit'});
      active = true;
    },
    buttons: {
      'Сохранить': function(){
        var content = CKEDITOR.instances['editor1'].getData();
        $('.error_messages').remove();
        $('.ui-dialog-buttonset').append($('<span/>',{ class: 'ajax_loading', style: 'float: left; margin: 10px 5px 0 0;' }));
        $.post(
          common_path+'&root_path='+info_path+'&cmd=put&target='+target,
          { content: content }
        )
        .success(function(){
          $('#info_ckeditor').dialog('close');
        })
        .error(function(){
          $('.ui-dialog-buttonset').append('<span style="color:red; float: left; margin: 10px 5px 0 0;" class="error_messages">Ошибка при сохранении! Обратитесь в службу поддержки.</span>');
        })
        .complete(function(){
          $('.ajax_loading').remove();
        });
      },
      'Отмена': function(){
        $(this).dialog('close');
      }
    }
  });

  choose_link.click(function(){
    $('.info_wrapper').append('<div class="iframe_wrpper">');

    $('#info_path').change(function(){
      var $this = $(this);
      var path_hash = $this.val();
      $.get(
        '/build_info_path',
        { decode: true, path_hash: path_hash },
        function(data){
          $this.val(data);
          $('.info_path_iframe_wrapper').dialog('close');
        });
    });

    $('<div/>',{ class: 'info_path_iframe_wrapper'}).appendTo('body').dialog({
      autoOpen: false,
      draggable: false,
      height: 450,
      modal: true,
      position: 'center',
      resizable: false,
      title: 'Дополнительная информация (досье)',
      width: 850,
      beforeClose: function(event, ui) {
        $('body').css({overflow: 'inherit'});
      }
    });

    $('.info_path_iframe_wrapper').html(
      $('<iframe/>',{ src: '/el_finder?', width:'825', height:'405', scrolling:'no'}).load(function(){
        $(".info_path_iframe_wrapper").css('display','block').dialog('open');
      })
    );

    return false;
  });


  var active = true;
  link.click(function(){
    if(!active){
      return false;
    };

    active = false;

    link.append($('<span/>', { class: 'ajax_loading'}));

    if (!info_path.length > 0){
      info_path = build_info_path();

      if (!info_path) {
        $('.ajax_loading').remove();
        return false;
      };
    };

    var file_name = info_path.match(/[^\/]*?$/)[0];
    var file_name_hash = encode_path_to_hash(file_name);
    info_path = info_path.replace(file_name,'');

    var ckeditor = CKEDITOR.instances['editor1'];

    if (!ckeditor){
      ckeditor = CKEDITOR.appendTo('info_ckeditor', { height: 435, resize_enabled: false });
    };

    $.get(common_path+'&root_path='+info_path+'&cmd=open&init=1', function(folder_data){
      var files = folder_data.files;
      var folder = folder_data.cwd;
      var file_content = '';
      var need_create_index_html = true;

      $(files).each(function(index, file){
        if (file.hash.match(file_name_hash)){
          need_create_index_html = false;
          $.get(common_path+'&root_path='+info_path+'&cmd=get&target='+file.hash, function(file_data){
            file_content = file_data.content;
            target = file.hash;
            ckeditor.setData(file_content);
            open_dialog();
          });
          return false;
        }
      });

      if (need_create_index_html){
        $.get(common_path+'&root_path='+info_path+'&cmd=mkfile&name='+file_name+'&target='+folder.hash, function(file_data){
          target = file_data.added[0].hash;
          open_dialog();
        });
      };
    });

    return false;
  });
});
