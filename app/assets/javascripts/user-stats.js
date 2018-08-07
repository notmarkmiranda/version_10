$(document).ready(function() {
  $('#user-season-navigator').change(function() {
    console.log(this.value)
    if (this.value !== '') {
      window.location.href = window.location.pathname + '?season=' + this.value
    } else if (this.value === 'all') {
      window.location.href = window.location.pathname
    }
  })
})
