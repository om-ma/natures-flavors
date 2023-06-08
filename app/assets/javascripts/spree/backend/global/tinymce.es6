document.addEventListener('DOMContentLoaded', function() {
  // eslint-disable-next-line no-undef
  tinymce.init({
    selector: '.spree-rte',
    plugins: [ "table", "fullscreen", "image", "code", "searchreplace", "wordcount", "visualblocks", "visualchars", "link", "charmap", "directionality", "nonbreaking", "media", "advlist", "autolink", "lists" ],
    menubar: "insert view format table tools",
    toolbar: 'undo redo | bold italic | link | forecolor backcolor | alignleft aligncenter alignright alignjustify | table | bullist numlist outdent indent | insert | uploadimage | code ',
    images_upload_url: '/admin/uploader/image',
    convert_urls: false,
    uploadimage: true
  });
})
