OpinionPoll::Application.routes.draw do
  root :to => "polls#index"

  resources :polls
  get 'vote/:answer_id', to: 'polls#vote', as: :vote_on_poll

end
