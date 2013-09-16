require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe PollsController do

  # This should return the minimal set of attributes required to create a valid
  # Poll. As you add validations to Poll, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { { "poll" => { #todo: generate these from FactoryGirl
     "question"=>"question1", 
     "answers_attributes"=>{"0"=>{"name"=>"a"}, "1"=>{"name"=>"b"}, "2"=>{"name"=>"c"}, "3"=>{"name"=>""}, "4"=>{"name"=>""}}} } }
   
  let(:poll) { FactoryGirl.build(:poll_with_answers) }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # PollsController. Be sure to keep this updated too.
  let(:valid_session) { {} }


  describe "GET index" do
    it "assigns all polls as @polls" do
      poll.save!
      get :index, {}, valid_session
      assigns(:polls).should eq([poll])
    end
  end

  describe "GET show" do
    it "assigns the requested poll as @poll" do
      poll.save!
      get :show, {:id => poll.to_param}, valid_session
      assigns(:poll).should eq(poll)
    end

    it "renders the voting template if has not been voted on" do
      poll.save!
      get :show, {:id => poll.to_param}, valid_session
      response.should render_template("show")
    end

    it "renders the results template if its already been voted on" do
      poll.save!
      controller.stub(:current_user).and_return("1234")
      FactoryGirl.create(:vote, :answer => poll.answers.first, :user => "1234")
      get :show, {:id => poll.to_param}, valid_session
      response.should render_template("show_results")
    end
  end

  describe "GET new" do
    it "assigns a new poll as @poll" do
      get :new, {}, valid_session
      assigns(:poll).should be_a_new(Poll)
    end
  end

  describe "GET edit" do
    it "assigns the requested poll as @poll" do
      poll.creator = "1234"
      poll.save!
      controller.stub(:current_user).and_return("1234")
      get :edit, {:id => poll.to_param}, valid_session
      assigns(:poll).should eq(poll)
    end

    it "always has additional answers built" do
      poll.creator = "1234"
      poll.save!
      controller.stub(:current_user).and_return("1234")
      get :edit, {:id => poll.to_param}, valid_session
      # there should always be Poll::MAX_ANSWERS number of answers
      assigns(:poll).answers.to_a.count.should eq(Poll::MAX_ANSWERS)
    end
  end

  describe "POST create"  do
    describe "with valid params" do
      it "creates a new Poll" do
        expect {
          post :create, valid_attributes, valid_session
        }.to change(Poll, :count).by(1)
      end

      it "assigns a newly created poll as @poll" do
        post :create,  valid_attributes, valid_session
        assigns(:poll).should be_a(Poll)
        assigns(:poll).should be_persisted
      end

      it "redirects to the created poll" do
        post :create, valid_attributes, valid_session
        response.should redirect_to(Poll.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved poll as @poll" do
        # Trigger the behavior that occurs when invalid params are submitted
        Poll.any_instance.stub(:save).and_return(false)
        post :create, {:poll => {  }}, valid_session
        assigns(:poll).should be_a_new(Poll)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Poll.any_instance.stub(:save).and_return(false)
        post :create, {:poll => {  }}, valid_session
        response.should render_template("new")
      end

      it "has additional answers built when none provided" do
        Poll.any_instance.stub(:save).and_return(false)
        post :create, {:poll => {  }}, valid_session
        # there should always be Poll::MAX_ANSWERS number of answers
        assigns(:poll).answers.to_a.count.should eq(Poll::MAX_ANSWERS)
      end

      it "always has additional answers built when one answer is provided", :focus => true do
        Poll.any_instance.stub(:save).and_return(false)
        post :create, { "poll" => { "question"=>"question1", "answers_attributes"=>{"0"=>{"name"=>"a"}, "1"=>{"name"=>""}, "2"=>{"name"=>""}, "3"=>{"name"=>""}, "4"=>{"name"=>""}}} }, valid_session
        # there should always be Poll::MAX_ANSWERS number of answers
        assigns(:poll).answers.to_a.count.should eq(Poll::MAX_ANSWERS)
      end
    end
  end

  describe "GET vote" , focus: true do
    describe "with valid params" do
      it "redirects to the poll after voting" do 
        poll.save!
        get :vote, {answer_id: poll.answers.first.id}, use_route: vote_on_poll_path(answer_id: poll.answers.first.id)
        response.should redirect_to(poll)
      end

      it 'increases the vote count by one' do
        poll.save!
        expect {
          get :vote, {answer_id: poll.answers.first.id}, use_route: vote_on_poll_path(answer_id: poll.answers.first.id)
        }.to change(Vote, :count).by(1)
      end
    end

    describe "with an invalid answer" do
      it "redirects to the poll after an unsuccessful vote" do
        poll.save!
        get :vote, {answer_id: poll.answers.first.id}, use_route: vote_on_poll_path(answer_id: poll.answers.first.id)
        response.should redirect_to(poll)
      end

      it "redirects to the index page with an invalid answer_id" do
        get :vote, {answer_id: '123232'}, use_route: vote_on_poll_path(answer_id: '123232')
        response.should redirect_to(polls_url)
      end

      it 'does not change the vote count' do
        poll.save!
        expect {
          get :vote, {answer_id: '123232'}, use_route: vote_on_poll_path(answer_id: '123232')
        }.to change(Vote, :count).by(0)
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested poll"do
        poll.save!
        # Assuming there are no other polls in the database, this
        # specifies that the Poll created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Poll.any_instance.should_receive(:update).with({ "question" => "another" })
        put :update, {:id => poll.to_param, :poll => { "question" => "another"  }}, valid_session
      end

      it "assigns the requested poll as @poll" do
        poll.creator = "1234"
        poll.save!
        controller.stub(:current_user).and_return("1234")
        put :update, {:id => poll.to_param, :poll => valid_attributes}, valid_session
        assigns(:poll).should eq(poll)
      end

      it "redirects to the poll" do
        poll.creator = "1234"
        poll.save!
        controller.stub(:current_user).and_return("1234")
        put :update, {:id => poll.to_param, :poll => valid_attributes}, valid_session
        response.should redirect_to(poll)
      end
    end

    describe "with invalid params" do
      it "assigns the poll as @poll" do
        poll.save!
        # Trigger the behavior that occurs when invalid params are submitted
        Poll.any_instance.stub(:save).and_return(false)
        put :update, {:id => poll.to_param, :poll => {  }}, valid_session
        assigns(:poll).should eq(poll)
      end

      it "re-renders the 'edit' template" do
        poll.save! 
        # Trigger the behavior that occurs when invalid params are submitted
        Poll.any_instance.stub(:save).and_return(false)
        put :update, {:id => poll.to_param, :poll => {  }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy"do
    it "destroys the requested poll" do
      poll.creator = "1234"
      poll.save!
      controller.stub(:current_user).and_return("1234")
      expect {
        delete :destroy, {:id => poll.to_param}, valid_session
      }.to change(Poll, :count).by(-1)
    end

    it "redirects to the polls list"  do
      poll.creator = "1234"
      poll.save!
      controller.stub(:current_user).and_return("1234")
      delete :destroy, {:id => poll.to_param}, valid_session
      response.should redirect_to(polls_url)
    end
  end

end
