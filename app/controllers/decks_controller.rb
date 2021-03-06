class DecksController < ApplicationController

  get '/decks' do
    if logged_in?
      @decks = Deck.all
      erb :"/decks/decks"
    else
      redirect '/'
    end
  end

  get '/decks/new' do
    if logged_in?
      erb :"/decks/new"
    else
      redirect '/'
    end
  end

  post '/decks' do
    deck = current_user.decks.build(params[:deck])
    if DeckParser.run(deck, params[:deck_list])
      deck.save
      redirect "/decks/#{deck.id}"
    else
      session[:error] = "deck list format is wrong, please make sure to have the right format."
      redirect "/decks/new"
    end
  end

  get '/decks/:id' do
    if logged_in?
      @deck = Deck.find(params[:id])
      erb :"/decks/show"
    else
      redirect '/'
    end
  end

  get '/decks/:id/edit' do
    if logged_in?
      @deck = Deck.find(params[:id])
      if current_user == @deck.user
        erb :"/decks/edit"
      else
        redirect "/decks/#{@deck.id}"
      end
    else
      redirect '/'
    end
  end

  patch '/decks/:id' do
    deck = Deck.find(params[:id])
    if current_user == deck.user
      deck.update(params[:deck])
      if DeckParser.run(deck, params[:deck_list])
        deck.save
        redirect "/decks/#{deck.id}"
      else
        session[:error] = "deck list format is wrong, please make sure to have the right format."
        redirect "/decks/#{deck.id}/edit"
      end
    else
      redirect "/decks/#{deck.id}"
    end
  end

  delete '/decks/:id/delete' do
    deck = Deck.find(params[:id])
    if current_user == deck.user
      deck.destroy
      redirect "/decks"
    else
      redirect "/decks/#{deck.id}"
    end
  end

end
