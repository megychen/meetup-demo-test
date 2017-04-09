require 'rails_helper'

RSpec.describe Meetup, type: :model do
  before do
    @user = User.create!(email: "test@gmail.com", password: "1234567", password_confirmation: "1234567")
  end
  it "is accessible" do
    meetup = Meetup.create!(:title => "title", user_id: @user.id)
    expect(meetup).to eq(Meetup.last)
  end

  it "has title description and user_id columns" do
    columns = Meetup.column_names
    expect(columns).to include("id")
    expect(columns).to include("title")
    expect(columns).to include("description")
    expect(columns).to include("user_id")
  end

  it "validates to title" do
    expect(Meetup.new).not_to be_valid
    expect(Meetup.new(title: "title", user_id: @user.id)).to be_valid
  end

  it ".no_description" do
    meetup_with_description = Meetup.create!(:title => "title", :description => "description", :user_id => @user.id)
    meetup_without_description = Meetup.create!(:title => "title", :description => nil, :user_id => @user.id)
    expect(Meetup.no_description).to include meetup_without_description
    expect(Meetup.no_description).not_to include meetup_with_description
  end

  it "#abstract" do
    meetup = Meetup.create!(:title => "title", :description => "12345678901234567890not_abstract", :user_id => @user.id)
    expect(meetup.abstract).to include("12345678901234567890")
    expect(meetup.abstract).not_to include("not_abstract")
  end

  it "has_many comments" do
    meetup = Meetup.create(:title => "title", :description => "description", :user_id => @user.id)
    comment = Comment.create!(:body => "body", :user_id => @user.id, :meetup_id => meetup.id)
    expect(meetup.comments).to include(comment)
  end
end
