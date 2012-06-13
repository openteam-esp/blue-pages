class Manage::InnorganizationsController < Manage::ApplicationController
  belongs_to :category, :optional => true
end
