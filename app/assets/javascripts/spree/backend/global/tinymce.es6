document.addEventListener('DOMContentLoaded', function() {
  // eslint-disable-next-line no-undef
  tinymce.init({
    selector: '.spree-rte',
    plugins: [ "image", "table", "code", "link", "table"],
    menubar: false,
    toolbar: 'undo redo | fontfamily fontsize blocks | bold italic link forecolor backcolor | alignleft aligncenter alignright alignjustify | table | bullist numlist outdent indent | code '
  });
})
