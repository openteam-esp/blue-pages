class InnorganizationsController < ApplicationController
  respond_to :json

  inherit_resources

  protected
    def collection
      results = Innorganization.search {
        paginate paginate_options
      }.results

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
