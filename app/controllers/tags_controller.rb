class TagsController < ApplicationController
  def index
    @tags = Tag.where(title: /#{params[:search]}/i).desc(:count)

    respond_to do |format|
      format.html
      format.json { render json: @tags }
    end
  end

  def show
    @tag = Tag.find(params[:id])
    @posts = @tag.posts.published.desc(:created_at).page(params[:page])

    respond_to do |format|
      format.html
      format.json { render json: @posts }
    end
  end
end
