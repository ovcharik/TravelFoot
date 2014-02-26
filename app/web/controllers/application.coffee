BaseController = require './base'

class ApplicationController extends BaseController
  @include ApplicationHelper
  
  @beforeFilter 'findCurrentUser'
  
module.exports = ApplicationController
