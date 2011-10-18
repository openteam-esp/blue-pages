class MainController < ApplicationController
  inherit_resources

  def index
    @subdivisions = Subdivision.all
  end

end
