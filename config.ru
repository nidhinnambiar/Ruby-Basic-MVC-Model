require 'rack'
require 'rack/server'
require './app/router.rb'
require './app/controller/person_controller.rb'
require './app/controller/session_controller.rb'

use Rack::CommonLogger
use Rack::ShowExceptions
use Rack::Static,
  :urls => ["/media/images", "/media/js", "/media/css"],
  :root => "public"

class Dispatcher

  def self.call(env)
    @request = Rack::Request.new env
    @req_path = @request.path_info
    @req_method = @request.request_method
    @req_params = @request.params
    controller_obj, action, id = Router.call(@req_path, @req_method, @req_params)
    response = Rack::Response.new
    @res = controller_obj.call(id)
    response.write @res
    response.finish
  end
end
run Dispatcher