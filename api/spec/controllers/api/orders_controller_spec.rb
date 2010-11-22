require 'spec_helper.rb'

describe Api::OrdersController do
  include Rack::Test::Methods

  def app
    Rails.application
  end

  let(:user) { mock_model(User, :has_role? => true, :valid_for_authentication? => true, :after_token_authentication => nil) }
  let(:order) { mock_model(Order, :to_json => "", :user => user) }

  before do
    Order.stub :find_by_param! => order
    User.stub(:find_for_token_authentication).with(:auth_token => VALID_TOKEN).and_return user
  end

  context "when valid api token" do
    let(:credentials) { encode_credentials(VALID_TOKEN) }

    describe "#show" do
      it "should return success" do
        get uri_for("/orders/R123456.json"), nil, {'HTTP_AUTHORIZATION' => credentials}
        last_response.status.should == 200
      end
      it "should return JSON for the specified order"
    end

    describe "#index" do

      context "when no search params" do
        it "should return success" do
          get  uri_for("/orders.json"), nil, {'HTTP_AUTHORIZATION' => credentials}
          last_response.status.should == 200
        end
        it "should return JSON for the first 100 orders"
      end

      context "when given search params" do
        it "should return success"
        it "should return JSON for the requested orders"
      end
    end
  end

  context "with no auth token" do
    describe "#show" do
      it "should return unauthorized" do
        get uri_for("/orders/R123456.json")
        last_response.status.should == 418
      end
    end

    describe "#index" do

      context "when no search params" do
        it "should return unauthorized" do
          get  uri_for("/orders.json")
          last_response.status.should == 418
        end
      end

      context "when given search params" do
        it "should return unauthorized"
        # pending "should return unauthorized" do
        #   get uri_for("/orders.json?search=#{@order}"), {:search => @order}
        #   last_response.status.should == 418
        # end
      end
    end
  end

  context "with bad auth token" do
    let(:credentials) { encode_credentials("") }

    describe "#show" do
      it "should return unauthorized" do
        get uri_for("/orders/R123456.json"), nil, {'HTTP_AUTHORIZATION' => credentials}
        last_response.status.should == 418
      end
    end

    describe "#index" do

      context "when no search params" do
        it "should return unauthorized" do
          get  uri_for("/orders.json"), nil, {'HTTP_AUTHORIZATION' => credentials}
          last_response.status.should == 418
        end
      end

      context "when given search params" do
        it "should return unauthorized"
        # pending "should return unauthorized" do
        #   get uri_for("/orders.json?search=#{@order}"), {:search => @order}, {'HTTP_AUTHORIZATION' => credentials}
        #   last_response.status.should == 418
        # end
      end
    end
  end
end
