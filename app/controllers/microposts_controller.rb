class MicropostsController < ApplicationController
  before_action :authenticate_user!, only: [:show, :create, :destroy]
  before_action :correct_user,   only: :destroy
  
  def index
    @microposts = Micropost.all
    @micropost = Micropost.new
  end

  def show
    @micropost = Micropost.find(params[:id])
    @comments = @post.comments
    @comment = Comment.new
  end

  def create
    # @micropost = Micropost.new(micropost_params)
    # @micropost.user_id = current_user.id
    # if @micropost.save
    #   redirect_back(fallback_location: root_path)
    # else
    #   redirect_back(fallback_location: root_path)
    # end
    @micropost = current_user.microposts.build(micropost_params)
    @micropost.user_id = current_user.id
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end

  def destroy
    @micropost.destroy
    flash[:success] = "Micropost deleted"
    redirect_to request.referrer || root_url
  end

  private

    def micropost_params
      params.require(:micropost).permit(:content, :picture)
    end


    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end
end