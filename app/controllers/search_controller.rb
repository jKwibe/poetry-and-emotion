class SearchController < ApplicationController
  def index
    @poems = SearchFacade.poems(params[:author])
  end
end
