class MicropostsController < ApplicationController
  before_action :require_login, only: %i[create destroy]
  before_action :correct_user, only: :destroy
  def create
    @micropost = current_user.microposts.build(micropost_param)
    if @micropost.save
      flash[:success] = 'Micropost saved.'
      redirect_to root_url
    else
      @feed_items = current_user.feed.paginate(page: params[:page])
      render 'static_pages/home', status: :unprocessable_entity
    end
  end

  def destroy
    Micropost.find(params[:id]).destroy
    flash[:success] = 'Micropost deleted'
    redirect_back_or_to root_url, status: :see_other
  end

  private

  def micropost_param
    params.require(:micropost).permit(:content)
  end

  def correct_user
    redirect_to root_url, status: :see_other unless current_user.microposts.any? do |micropost|
      micropost.id == params[:id].to_i
    end
  end
end
