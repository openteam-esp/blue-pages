class InnorganizationsController < ApplicationController
  inherit_resources

  action :index, :show

  respond_to :json

  def index
    index! do |success|
      success.json {
        render :json => {
          :organizations => collection.map { |o| o.to_json(false) },
          :filters => Innorganization.filters
        }
      }
    end
  end

  def show
    show! do |success|
      success.json { render :json => {
          :organization => resource.to_json(false),
          :filters => Innorganization.filters
        }
      }
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
