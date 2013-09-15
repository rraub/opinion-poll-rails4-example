OpinionPoll::Application.routes.draw do
  root :to => "polls#index"

  resources :polls
end
