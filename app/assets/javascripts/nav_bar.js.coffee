@module 'NavBar', ->
  @module 'InitialGooglePic', ->
    @init =->
      $('.profile-pic').initial
        width: 46
        height: 46
        fontSize: 20
        fontWeight: 400
        fontFamily: 'HelveticaNeue-Light,Helvetica Neue Light,Helvetica Neue,Helvetica, Arial,Lucida Grande, sans-serif'

$ ->
  NavBar.InitialGooglePic.init() if $('.navbar .profile-pic').length

