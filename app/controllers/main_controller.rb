class MainController < ApplicationController

  inherit_resources

  layout "public/main"

  def index
    @subdivisions = Subdivision.roots.order('position')
  end

end
