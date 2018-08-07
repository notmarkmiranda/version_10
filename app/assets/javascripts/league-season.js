$(document).ready(function() {
  $('#all-season-navigator').change(function() {
    if (this.value !== '') {
      window.location.href = '/seasons/' + this.value
    }
  })
})
