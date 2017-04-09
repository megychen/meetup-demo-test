require 'rails_helper'

RSpec.describe MeetupsController, type: :controller do
  before do
    @user = User.create!(email: "test@gmail.com", password: "1234567", password_confirmation: "1234567")
    @user_0 = User.create!(email: "test1@gmail.com", password: "1234567", password_confirmation: "1234567")
    @meetup_0 = Meetup.create!(title: "foo", description: "bar", user_id: @user.id)
  end
  it "#index" do
    get :index
    expect(response).to have_http_status(200)
    expect(response).to render_template(:index)
  end

  it "#show" do
    get :show, id: @meetup_0[:id]
    expect(response).to have_http_status(200)
    expect(response).to render_template(:show)
  end

  describe "#new" do
    it "user doesn't login" do
      get :new
      expect(response).to have_http_status(302)
      expect(response).to redirect_to new_user_session_path
    end
    it "text" do
      sign_in(@user)
      get :new
      expect(response).to have_http_status(200)
      expect(response).to render_template(:new)
    end
  end

  describe "#create" do
    before do
      sign_in(@user)
      @meetup_params = { :title => "foo1", user_id: @user.id }
    end
    it "create records" do
      expect{ post :create, meetup: @meetup_params }.to change{ Meetup.all.size }.by(1)
    end
    it "redirect on success" do
      post :create, meetup: @meetup_params
      expect(response).not_to have_http_status(200)
      expect(response).to have_http_status(302)
      expect(response).to redirect_to meetups_path
    end
    it "render :new on fail" do
      allow_any_instance_of(Meetup).to receive(:save).and_return(false)
      post :create, meetup: @meetup_params
      expect(response).not_to have_http_status(302)
      expect(response).to render_template(:new)
    end
  end

  describe "#edit" do
    before do
      @meetup_1 = Meetup.create!(title: "foo", description: "bar", user_id: @user_0.id)
    end
    it "user doesn't login" do
      get :edit, id: @meetup_0[:id]
      expect(response).to have_http_status(302)
      expect(response).to redirect_to new_user_session_path
    end

    it "user login but has no permission" do
      sign_in(@user)
      get :edit, id: @meetup_1[:id]
      expect(response).to have_http_status(302)
      expect(response).to redirect_to root_path
    end

    it "user login and has permission" do
      sign_in(@user)
      get :edit, id: @meetup_0[:id]
      expect(response).to have_http_status(200)
      expect(response).to render_template(:edit)
    end
  end

  describe "#update" do
    before do
      sign_in(@user)
      @meetup_params = { title: "bar" }
    end
    it "changes record" do
      post :update, meetup: @meetup_params, id: @meetup_0[:id]
      expect(Meetup.find(@meetup_0[:id])[:title]).to eq("bar")
    end

    it "redirect on success" do
      post :update, meetup: @meetup_params, id: @meetup_0[:id]
      expect(response).not_to have_http_status(200)
      expect(response).to have_http_status(302)
      expect(response).to redirect_to meetups_path
    end

    it "render :edit on fail" do
      allow_any_instance_of(Meetup).to receive(:update).and_return(false)
      post :update, meetup: @meetup_params, id: @meetup_0[:id]
      expect(response).not_to have_http_status(302)
      expect(response).to render_template(:edit)
    end
  end

  describe "#destroy" do
    before do
      sign_in(@user)
      @meetup_1 = Meetup.first || Meetup.create!(:title => "title_2", user_id: @user.id)
      @meetup_2 = Meetup.create!(title: "foo2", description: "bar", user_id: @user_0.id)
    end

    it "destroy record" do
      expect{ delete :destroy, id: @meetup_1[:id] }.to change{ Meetup.all.size }.by(-1)
    end

    it "redirect_to index after destroy" do
      delete :destroy, id: @meetup_1[:id]
      expect(response).to have_http_status(302)
      expect(response).to redirect_to meetups_path
    end

    it "redirect_to root_path if no permission" do
      delete :destroy, id: @meetup_2[:id]
      expect(response).to have_http_status(302)
      expect(response).to redirect_to root_path
    end
  end
end
