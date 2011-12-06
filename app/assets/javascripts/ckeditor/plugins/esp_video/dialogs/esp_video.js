CKEDITOR.dialog.add('esp_video',function(f){var g=f.lang.esp_video;function commitValue(a,b){var c=this.getValue();if(!c&&this.id=='id')c=generateId();a.setAttribute(this.id,c);if(!c)return;switch(this.id){case'poster':b.backgroundImage='url('+c+')';break;case'width':b.width=c+'px';break;case'height':b.height=c+'px';break}}function commitSrc(a,b,c){var d=this.id.match(/(\w+)(\d)/),id=d[1],number=parseInt(d[2],10);var e=c[number]||(c[number]={});e[id]=this.getValue()}function loadValue(a){if(a)this.setValue(a.getAttribute(this.id));else{if(this.id=='id')this.setValue(generateId())}}function loadSrc(a,b){var c=this.id.match(/(\w+)(\d)/),id=c[1],number=parseInt(c[2],10);var d=b[number];if(!d)return;this.setValue(d[id])}function generateId(){var a=new Date();return'video'+a.getFullYear()+a.getMonth()+a.getDate()+a.getHours()+a.getMinutes()+a.getSeconds()}var h=function(){var a=this.previewImage;a.removeListener('load',h);a.removeListener('error',i);a.removeListener('abort',i);this.setValueOf('info','width',a.$.width);this.setValueOf('info','height',a.$.height)};var i=function(){var a=this.previewImage;a.removeListener('load',h);a.removeListener('error',i);a.removeListener('abort',i)};return{title:g.dialogTitle,minWidth:400,minHeight:140,onShow:function(){this.fakeImage=this.videoNode=null;this.previewImage=f.document.createElement('img');var a=this.getSelectedElement();if(a&&a.data('cke-real-element-type')&&a.data('cke-real-element-type')=='video'){this.fakeImage=a;var b=f.restoreRealElement(a),videos=[];videos.push({src:b.getAttribute('src')});this.videoNode=b;this.setupContent(b,videos)}else this.setupContent(null,[])},onOk:function(){var a=null;if(!this.fakeImage){a=CKEDITOR.dom.element.createFromHtml('<cke:video></cke:video>',f.document);a.setAttributes({controls:'controls',src:this.getValueOf('info','src0')})}else{a=this.videoNode}var b={},videos=[];this.commitContent(a,b,videos);var c='',links='',link=g.linkTemplate||'',fallbackTemplate=g.fallbackTemplate||'';links=link.replace('%src%',this.getValueOf('info','src0')).replace('%type%',this.getValueOf('info','src0').split('/').pop());a.setHtml(c+fallbackTemplate.replace('%links%',links));var d=f.createFakeElement(a,'cke_video','video',false);d.setStyles(b);if(this.fakeImage){d.replace(this.fakeImage);f.getSelection().selectElement(d)}else f.insertElement(d)},onHide:function(){if(this.previewImage){this.previewImage.removeListener('load',h);this.previewImage.removeListener('error',i);this.previewImage.removeListener('abort',i);this.previewImage.remove();this.previewImage=null}},contents:[{id:'info',elements:[{type:'hbox',widths:['320px','80px'],children:[{type:'text',id:'src0',label:g.sourceVideo,commit:commitSrc,setup:loadSrc},{type:'button',id:'browse',hidden:'true',style:'display:inline-block;margin-top:10px;',filebrowser:{action:'Browse',target:'info:src0',url:f.config.filebrowserVideoBrowseUrl||f.config.filebrowserBrowseUrl},label:f.lang.esp_video.browseServer}]},{type:'hbox',widths:['50%','50%'],children:[{type:'text',id:'width',label:f.lang.common.width,'default':512,validate:CKEDITOR.dialog.validate.notEmpty(g.widthRequired),commit:commitValue,setup:loadValue},{type:'text',id:'height',label:f.lang.common.height,'default':410,validate:CKEDITOR.dialog.validate.notEmpty(g.heightRequired),commit:commitValue,setup:loadValue}]},{type:'hbox',widths:['320px','80px'],children:[{type:'text',id:'poster',label:g.poster,commit:commitValue,setup:loadValue,onChange:function(){var a=this.getDialog(),newUrl=this.getValue();if(newUrl.length>0){a=this.getDialog();var b=a.previewImage;b.on('load',h,a);b.on('error',i,a);b.on('abort',i,a);b.setAttribute('src',newUrl)}}},{type:'button',id:'browse',hidden:'true',style:'display:inline-block;margin-top:10px;',filebrowser:{action:'Browse',target:'info:poster',url:f.config.filebrowserImageBrowseUrl||f.config.filebrowserBrowseUrl},label:f.lang.esp_video.browseServer}]}]}]}});

