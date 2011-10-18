class ApplicationController < ActionController::Base
  has_searcher

  inherit_resources

  protect_from_forgery
end
