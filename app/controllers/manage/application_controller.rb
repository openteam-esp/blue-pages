class Manage::ApplicationController < ApplicationController
  sso_load_and_authorize_resource

  layout 'manage/with_tree'
end
