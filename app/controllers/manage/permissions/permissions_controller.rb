class Manage::Permissions::PermissionsController < Manage::Permissions::ApplicationController
  belongs_to :user, :shallow => true
  actions :new, :create, :destroy
end
