class ApplicationController < ActionController::Base
  has_searcher

  protect_from_forgery
end
