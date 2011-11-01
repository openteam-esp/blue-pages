class CategoriesController < ApplicationController

  inherit_resources

  actions :show

  layout "public/main"
end
