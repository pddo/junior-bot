require File.expand_path '../../test_helper.rb', __FILE__

describe 'Junior Bot' do
  it 'should successfully return a greeting' do
    get '/'
    last_response.body.must_include 'Hello! Welcome to Junior Slackbot'
  end
end
