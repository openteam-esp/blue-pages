class CategoriesController < ApplicationController

  inherit_resources

  layout "public/main"

  def index
    output = BluePagesBook.new(:page_size => 'A4', :margin => [50,38,25,50]).to_pdf

    respond_to do |format|
      format.pdf do
        send_data output, :filename => "BluePagesBook.pdf", :type => "application/pdf", :disposition => 'inline'
      end
    end
  end

end
