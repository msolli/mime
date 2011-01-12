require 'spec_helper'

class JsonSearchController
  include ActionController::Testing
  
  def self.protected_instance_variables
    []
  end
end

describe JsonSearchController do
  it 'should require :model and :query' do
    get :new
    response.should_not be_success
  end
  it 'should respond with json' do
    get :new, {:model => 'article', :query => 'asd'}
    response.should be_success
    response.body.should eql('[]')
  end
end
