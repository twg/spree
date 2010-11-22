require 'spec_helper.rb'

describe Api::StatesController do
  include Rack::Test::Methods

  def app
    Rails.application
  end

  let(:user) { mock_model(User, :has_role? => true, :valid_for_authentication? => true, :after_token_authentication => nil) }
  let(:state) { mock_model(State, :to_json => "") }
  let(:country) { mock_model(Country) }

  before do
    Country.stub :find => country
    country.stub_chain(:states, :scoped, :find => state)
    User.stub(:find_for_token_authentication).with(:auth_token => VALID_TOKEN).and_return user
    User.stub(:find_for_token_authentication).with(:auth_token => "foo").and_return nil
  end

  context "when valid api token" do
    let(:credentials) { encode_credentials(VALID_TOKEN) }

    describe "#show" do
      it "should return success" do
        get uri_for("/countries/214/states/1.json"), nil, {'HTTP_AUTHORIZATION' => credentials}
        last_response.status.should == 200
      end
    end

    describe "#index" do

      context "when no search params" do
        it "should return success" do
          get uri_for("/states.json"), nil, {'HTTP_AUTHORIZATION' => credentials}
          last_response.status.should == 200
        end
      end
    end

  end

  context "when no api token" do

    describe "#show" do
      it "should return unauthorized" do
        get uri_for("/countries/214/states/1.json"), nil
        last_response.status.should == 418
      end
    end

    describe "#index" do

      context "when no search params" do
        it "should return unauthorized" do
          get uri_for("/states.json"), nil
          last_response.status.should == 418
        end
      end
    end

  end

  context "when bad api token" do
    let(:credentials) { encode_credentials("foo") }

    describe "#show" do
      it "should return unauthorized" do
        get uri_for("/countries/214/states/1.json"), nil, {'HTTP_AUTHORIZATION' => credentials}
        last_response.status.should == 418
      end
    end

    describe "#index" do

      context "when no search params" do
        it "should return unauthorized" do
          get uri_for("/states.json"), nil, {'HTTP_AUTHORIZATION' => credentials}
          last_response.status.should == 418
        end
      end
    end

  end

end