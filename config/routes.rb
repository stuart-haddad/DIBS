class JsonOnly
  def matches?(request)
    request.format == :json
  end
end

Rails.application.routes.draw do
  scope "oauth" do
    get "authorize", to: "oauth#authorize"
    get "callback", to: "oauth#callback"
    get "sign_out", to: "oauth#sign_out"
  end

  resources :calendars, constraints: { id: /[0-z\.]+/ }

  get "calendars/bookNextHour/:id", to: "calendars#bookNextHour", as: "bookHour", constraints: { id: /[0-z\.]+/ }
  get "calendars/bookNext30Minutes/:id", to: "calendars#bookNext30Minutes", as: "book30", constraints: { id: /[0-z\.]+/ }
  get "calendars/bookTilNext/:id", to: "calendars#bookTilNext", as: "bookTil", constraints: { id: /[0-z\.]+/ }

  scope "api" do
    constraints format: :json do
      get "calendars", to: "api#calendars", as: :calendars_api
      get "calendars/:id", to: "api#calendar", as: :calendar_api, constraints: { id: /[0-z\.]+/ }
    end
  end

  root to: "calendars#index"
end
