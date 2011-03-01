require 'spec_helper'

describe JsonSearchController do
  it 'should require :model and :query' do
    get '/fastsearch'
    response.should_not be_success
  end
  it 'should respond with json' do
    get '/fastsearch?model=article&query=asd'
    # get :new, {:model => 'article', :query => 'asd'}
    response.should be_success
    response.body.should eql('[]')
  end
end
