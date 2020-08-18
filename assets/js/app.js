import "../css/app.scss"
import "phoenix_html"

$(function () {
  $("a[rel~=popover], .has-popover").popover()
  $("a[rel~=tooltip], .has-tooltip").tooltip()
  $('[data-toggle="tooltip"]').tooltip()
})

