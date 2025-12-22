class MicropostsController < ApplicationController
  before_action :logged_in_user, only: %i[create destroy]
  def create
    @micropost = current_user.microposts.build(micropost_param)
    if @micropost.save
      flash[:success] = 'Micropost saved.'
      redirect_to root_url
    else
      render 'static_pages/home', status: :unprocessable_entity
    end
  end

  def destroy; end

  private

  def micropost_param
    params.require(:micropost).permit(:content)
  end
end
