class Admin::ApplicationController < ApplicationController
  inherit_resources
  layout 'admin/with_tree'
end
