class MowersController < ApplicationController
  skip_before_action :authenticate_user!, only: :index

  def index
    @mowers = Mower.all

    @markers = User.all.geocoded.map do |user|
      {
        lat: user.latitude,
        lng: user.longitude
      }
    end
  end

  def new
    @mower = Mower.new
    @user = current_user
  end

  def create
    @mower = Mower.new(mower_params)
    @mower.user = current_user
    @mower.save ? redirect_to(user_path(@mower.user)) : (render :new)
  end

  def edit
    @mower = Mower.find(params[:id])
  end

  def update
    @mower = Mower.find(params[:id])
    @mower.update(mower_params)

    redirect_to(user_path(@mower.user))
  end

  def show
    @mower = Mower.find(params[:id])
    @booking = Booking.new
    @user = @mower.user
    @marker = @user.geocoded? ? [{lat: @user.latitude, lng: @user.longitude}] : []
  end

  def destroy
    @mower = Mower.find(params[:id])
    @mower.destroy
    redirect_to user_path(current_user)
  end

  private

  def mower_params
    params.require(:mower).permit(:price_per_day, :title, :description, :photo)
  end
end
