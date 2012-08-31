class ApplicationController < ActionController::Base
  protect_from_forgery

  def render_404
    raise Mongoid::Errors::DocumentNotFound.new(Object, {}, nil)
  end
end
