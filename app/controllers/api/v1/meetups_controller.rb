class Api::V1::MeetupsController < ApiController
  before_action :authenticate_user!, :only => [:index]
  
  def index
    @meetups = Meetup.all
    render :json => {
      :data => @meetups.map{ |meetup|
        {
          :title => meetup.title,
          :description => meetup.description,
          :published_time => meetup.created_at
        }
      }
    }
  end
end
