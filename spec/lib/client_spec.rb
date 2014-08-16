require 'spec_helper'

describe Echochamber::Client do

  let(:app_id)        { "9QCM5C6Y2AX82M" }
  let(:app_secret)    { "390db093ee6f71ffc6d488b9457593a7" }
  let(:api_key)       { "XCNLJFG83URX95Y" }
  let(:email)         { "cthomas@railjumper.com" }
  let(:password)      { "vvidmk" }

  let(:credentials) do  
    Echochamber::Credentials.build(app_id, app_secret, api_key, email, password)
  end

  let (:user_params) do
    {
      firstName:  'JohnQ',
      lastName:   'Public',
      email:      'publius@comcast.net',
      password:   'kN12oK9p!3',
      title:      'Hedge Wizard'

    }
  end

  let(:client) do
    VCR.use_cassette('get_token', :record => :once) do
      Echochamber::Client.new(credentials) 
    end
  end


  describe '#initialize' do
    pending 'calls Echochamber::Request.get_token with credentials'
  end

  describe '.create_user' do

    it 'returns the User ID' do
      VCR.use_cassette('create_user', :record => :once) do
        user_id = client.create_user(user_params)
        expect(user_id).to_not be_nil
      end
    end
  end

end # describe Echochamber::Client


