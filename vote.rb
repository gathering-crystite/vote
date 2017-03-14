require 'sinatra'
require 'yaml/store'

set :port, 1234

get '/' do
  @title = 'Vote For the Tree Of The Day.'
  erb :index
end

Choices = {
  'ONE' => 'Tree #1',
  'TWO' => 'Tree #2',
  'THR' => 'Tree #3',
  'FOUR' => 'Tree #4',
}


post '/cast' do
  @title = 'Thank you for voting.'
  @vote  = params['vote']
  @store = YAML::Store.new 'votes.yml'
  @store.transaction do
    @store['votes'] ||= {}
    @store['votes'][@vote] ||= 0
    @store['votes'][@vote] += 1
  end
  erb :cast
end

get '/results' do
  @title = 'Results so far:'
  @store = YAML::Store.new 'votes.yml'
  @votes = @store.transaction { @store['votes'] }
  erb :results
end
