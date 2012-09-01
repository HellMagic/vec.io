class TagsController < ApplicationController
  def index
    @tags = Tag.where(title: /#{params[:search]}/i).desc(:count)

    respond_to do |format|
      format.html
      format.json { render json: @tags }
    end
  end

  def show
  end
end
