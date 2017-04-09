class MeetupsController < ApplicationController
  before_action :authenticate_user!, :except => [:index, :show]
  before_action :find_meetup_and_check_permission, :only => [:edit, :update, :destroy]

  def index
    @meetups = Meetup.all
  end

  def show
    @meetup = Meetup.find(params[:id])
    @comments = @meetup.comments
  end

  def new
    @meetup = Meetup.new
  end

  def create
    @meetup = Meetup.create(meetup_params)
    @meetup.user = current_user
    if @meetup.save
      redirect_to meetups_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @meetup.update(meetup_params)
      redirect_to meetups_path, notice: "Update Success"
    else
      render :edit
    end
  end

  def destroy
    @meetup.destroy
    redirect_to meetups_path, alert: "Meetup Deleted"
  end

  private

  def find_meetup_and_check_permission
    @meetup = Meetup.find(params[:id])
    if @meetup.user != current_user
      flash[:alert] = "You have no permission"
      redirect_to root_path
    end
  end

  def meetup_params
    params.require(:meetup).permit(:title, :description)
  end
end
