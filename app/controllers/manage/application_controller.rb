class Manage::ApplicationController < ApplicationController
  before_filter :authenticate_user!
  layout 'manage/with_tree'
  inherit_resources
  load_and_authorize_resource
end
