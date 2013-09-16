class PollsController < ApplicationController
  before_action :set_poll, only: [:show, :edit, :update, :destroy]

  # GET /polls
  def index
    @polls = Poll.all
  end

  # GET /vote/1
  def vote
    # params[:answer_id]
    answer = Answer.where(id: params[:answer_id]).first
    if(!answer.nil? and !answer.poll.has_been_voted_on_by(current_user))
      vote = Vote.new(answer_id: answer.id, user: current_user)
      if(vote.save!)
        redirect_to answer.poll
      end
    else
      redirect_to polls_url, notice: 'Invalid Vote Request'
    end
  end

  # GET /polls/1
  # GET /polls/1.json
  def show
    if(@poll.has_been_voted_on_by current_user)
      render action: 'show_results' 
    end
  end

  # GET /polls/new
  def new
    #todo: handel errors when creating a new poll
    @poll = Poll.new
    (Poll::MAX_ANSWERS - @poll.answers.to_a.count).times do
      @poll.answers.build
    end
  end

  # GET /polls/1/edit
  def edit
    unless(@poll.updatable_by?(current_user))
      redirect_to @poll, notice: 'Poll is not updatable'
    else
      # if they wish to add more answers, build the remaining placeholders
      (Poll::MAX_ANSWERS - @poll.answers.to_a.count).times do 
         @poll.answers.build
       end
    end

  end

  # POST /polls
  def create
    @poll = Poll.new(poll_params)
    @poll.creator = current_user
    @poll.answers.each do |a| a.poll_id = @poll.id end 

    respond_to do |format|
      if @poll.save
        format.html { redirect_to @poll, notice: 'Poll was successfully created.' }
      else
        (Poll::MAX_ANSWERS - @poll.answers.to_a.count).times do 
          @poll.answers.build
        end
        format.html { render action: 'new' }
      end
    end
  end

  # PATCH/PUT /polls/1
  def update
    @poll.answers.each do |a| a.poll_id = @poll.id end
    respond_to do |format|
      if @poll.update(poll_params)
        format.html { redirect_to @poll, notice: 'Poll was successfully updated.' }
      else
        (Poll::MAX_ANSWERS - @poll.answers.to_a.count).times do 
          @poll.answers.build
        end
        format.html { render action: 'edit' }
      end
    end
  end

  # DELETE /polls/1
  def destroy
    if(@poll.updatable_by?(current_user))
      @poll.destroy
      redirect_to polls_url
    else
      redirect_to polls_url, notice: 'invalid request'
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_poll
      @poll = Poll.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def poll_params
      params[:poll].permit(:question, answers_attributes: [:name, :id] )
    end
end
