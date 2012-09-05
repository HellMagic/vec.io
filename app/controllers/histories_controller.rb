class HistoriesController < ApplicationController
  before_filter :authenticate_user!, :find_post

  def index
    @histories = @post.history_tracks.desc(:created_at).page(params[:page]).per(32)

    respond_to do |format|
      format.html
      format.json { render json: @histories }
    end
  end

  def show
    respond_to do |format|
      format.html
      format.json { render json: @history }
    end
  end

  def destroy
    @history.destroy

    respond_to do |format|
      format.html { redirect_to post_histories_url(@post), notice: t('flash.histories.success.destroy') }
      format.json { head :no_content }
    end
  end

  private
  def find_post
    @post = Post.find(params[:post_id])
    @history = @post.history_tracks.find(params[:id]) if params[:id]
  end
end
