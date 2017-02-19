'use strict'

angular.module('feryzApp', [
  'ngAnimate'
  'ngCookies'
  'ngResource'
  'ngRoute'
  'ngSanitize'
  'ui.router'
  'ui.bootstrap'
  'ui.select'
  'pascalprecht.translate'
  'angular-loading-bar'
  'toastr'
  'http-auth-interceptor'
  'ui.grid'
  'ui.grid.edit'
  'ui.grid.resizeColumns'
  'ui.grid.exporter'
  'ui.grid.selection'
  'FBAngular'
  'ngMaterial'
  'angular-svg-round-progress'
  'camera'
  'ngFileUpload'
])
#- Valores que usaremos para nuestro proyecto
.constant('App', (()->

  dominio = location.protocol + '//' + location.hostname + '/'
  #dominio = 'http://olimpiadaslibertad.com/'
  #dominio = 'http://192.168.1.100/'
  
  #console.log 'Entra al dominio: ', location.hostname
  
  if(location.hostname.match('lalvirtual'))
    dominio = 'http://lalvirtual.com/'
    
  server = dominio + 'feryz_server/public/'
  frontapp = dominio + 'feryz/'
  


  return {
    Server: server
    views: 'views/'
    #views: server + 'views/dist/views/' # Para el server Laravel
    images: server + 'images/'
    perfilPath: server + 'images/perfil/'
    imgSystemPath: server + 'images/eventos/'
  }
)())


.constant('AUTH_EVENTS', {
  loginSuccess: 'auth-login-success',
  loginFailed: 'auth-login-failed',
  logoutSuccess: 'auth-logout-success',
  sessionTimeout: 'auth-session-timeout',
  notAuthenticated: 'auth-not-authenticated',
  notAuthorized: 'auth-not-authorized'
})
.constant('USER_ROLES', {
  all:            '*',
  admin:          'admin',
  vendedor:       'vendedor',
  tecnico:        'tecnico'
})
.constant('PERMISSIONS', {
  can_work_like_admin:            'can_work_like_admin'
  can_work_like_vendedor:         'can_work_like_vendedor'
  can_work_like_tecnico:          'can_work_like_tecnico'
  can_edit_usuarios:              'can_edit_usuarios'
})

