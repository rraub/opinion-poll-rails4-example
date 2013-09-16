class PollsController < ApplicationController
  before_action :set_poll, only: [:show, :edit, :update, :destroy]

  # GET /polls
  def index
    @polls = Poll.all
    if(@polls.empty?)
      render action: 'index_no_polls'
    end      
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
    @poll = Poll.new
    @poll.build_placeholder_answers
  end

  # GET /polls/1/edit
  def edit
    unless(@poll.updatable_by?(current_user))
      redirect_to @poll, notice: 'Poll is not updatable'
    else
      @poll.build_placeholder_answers
    end
  end

  # POST /polls
  def create
    @poll = Poll.new(poll_params)
    @poll.creator = current_user

    respond_to do |format|
      if @poll.save
        format.html { redirect_to @poll, notice: 'Poll was successfully created.' }
      else
        @poll.build_placeholder_answers
        format.html { render action: 'new' }
      end
    end
  end

  # PATCH/PUT /polls/1
  def update
    if(@poll.updatable_by?(current_user))
      respond_to do |format|
        if @poll.update(poll_params)
          format.html { redirect_to @poll, notice: 'Poll was successfully updated.' }
        else
          @poll.build_placeholder_answers
          format.html { render action: 'edit' }
        end
      end
    else
      redirect_to @poll, notice: 'Invalid Request'
    end
  end

  # DELETE /polls/1
  def destroy
    if(@poll.creator  == current_user)
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
