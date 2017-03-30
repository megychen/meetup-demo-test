class MeetupsController < ApplicationController
  before_action :authenticate_user!, :except => [:index, :show]
  before_action :find_meetup, :only => [:show, :edit, :update, :destroy]

  def index
    @meetups = Meetup.all
  end

  def show
  end

  def new
    @meetup = Meetup.new
  end

  def create
    @meetup = Meetup.create(meetup_params)
    redirect_to meetups_path
  end

  def edit
  end

  def update
    @meetup.update(meetup_params)
    @meetup.save
    redirect_to meetups_path, notice: "Update Success"
  end

  def destroy
    @meetup.destroy
    redirect_to meetups_path, alert: "Meetup Deleted"
  end

  private

  def find_meetup
    @meetup = Meetup.find(params[:id])
  end

  def meetup_params
    params.require(:meetup).permit(:title, :description)
  end
end
