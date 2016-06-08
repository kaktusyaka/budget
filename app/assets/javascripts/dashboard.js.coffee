@module 'Dashboard', ->
  @init =->
    scrollingPage()

    $('body').flipLightBox
      lightbox_text_status: 0
      lightbox_navigation_status: 0

    new WOW({}).init()
    $('.parallax-window').parallax imageSrc: '/3.png'

  #jQuery for page scrolling feature - requires jQuery Easing plugin
  scrollingPage = ->
    $('.navbar-nav li a').bind 'click', (event) ->
      $anchor = $(@)
      nav = $($anchor.attr('href'))
      if nav.length
        $('html, body').stop().animate { scrollTop: $($anchor.attr('href')).offset().top }, 1500, 'easeInOutExpo'
        event.preventDefault()
      return
    return
$ ->
  Dashboard.init() if $('#home-index').length
