$(document).ready(function () {
  $("#micropost_picture").change(function() {
    let size_in_megabytes = this.files[0].size/1024/1024;
    let max_size = this.dataset.maxSize;
    if (size_in_megabytes > max_size) {
      alert(this.dataset.notification);
    }
  });
});
