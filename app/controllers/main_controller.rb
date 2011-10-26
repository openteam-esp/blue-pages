class MainController < ApplicationController

  layout "public/main"

  def index
    @roots = Subdivision.roots
  end

  def search
    searcher.pagination = paginate_options
    @results = searcher.results
  end

  protected

  def paginate_options(options={})
    {
      :page       => params[:page],
      :per_page   => 10
    }.merge(options)
  end

  def resource_instance_name
    :main
  end

end
