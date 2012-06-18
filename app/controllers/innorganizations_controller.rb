class InnorganizationsController < ApplicationController
  inherit_resources

  action :index, :show

  respond_to :json

  def index
    index! do |success|
      success.json {
        render :json => {
          :organizations => collection.as_json,
          :filters => Innorganization.filters
        }
      }
    end
  end

  def show
    show! do |success|
      success.json { render :json => resource.to_json(params[:expand], params[:sync]) }
    end
  end

  protected
    def collection
      results = Innorganization.sunspot_results(params, paginate_options)

      headers['X-Current-Page'] = results.current_page.to_s
      headers['X-Total-Pages'] = results.total_pages.to_s
      headers['X-Total-Count'] = results.total_count.to_s

      results
    end

    def paginate_options
      {
        :page       => params[:page],
        :per_page   => params[:per_page]
      }
    end
end
