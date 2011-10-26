class SubdivisionsController < ApplicationController

  inherit_resources

  layout "public/main"

  protected

  def collection
    Subdivision.roots
  end

end
