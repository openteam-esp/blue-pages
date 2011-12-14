class ItemsController < ApplicationController
  inherit_resources

  actions :show

  belongs_to :category

  layout "public/main"
end
