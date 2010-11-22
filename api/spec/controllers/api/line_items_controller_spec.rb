require 'spec_helper.rb'

describe Api::LineItemsController do
  # using this to simutanitously test routes
  include Rack::Test::Methods

  def app
    Rails.application
  end

  let(:order) { Order.new }
  let(:line_item) { mock_model(LineItem, :update_attributes => true) }
  let(:user) { mock_model(User, :has_role? => true, :valid_for_authentication? => true, :after_token_authentication => nil) }

  before do
    Order.stub :find_by_param! => order
    User.stub(:find_for_token_authentication).with(:auth_token => VALID_TOKEN).and_return user
    User.stub(:find_for_token_authentication).with(:auth_token => "foo").and_return nil
  end

  context "with valid auth token" do
    let(:credentials) { encode_credentials(VALID_TOKEN) }

    describe "GET index" do
      it 'should GET list of Line Items' do
        get uri_for("/orders/R123456/line_items.json"), nil, {'HTTP_AUTHORIZATION' => credentials}
        response.should be_success
      end
    end

    describe "GET show" do
     # before { order.stub_chain(:line_items, :scoped, :find => line_item) }

      it "should GET a single Line Item" do
        get uri_for("/orders/R123456/line_items/1.json"), nil, {'HTTP_AUTHORIZATION' => credentials}
        response.should be_success
      end
    end

    describe "POST create" do

      it "should POST new data to Line Items" do
        post uri_for("/orders/R123456/line_items.json"), nil, {'HTTP_AUTHORIZATION' => credentials}
        response.should be_success
      end
    end

    describe "PUT update" do
      before { order.stub_chain(:line_items, :scoped, :find => line_item) }

      it "should PUT updated data into Line Items" do
        put uri_for("/orders/R123456/line_items/1.json"), nil, {'HTTP_AUTHORIZATION' => credentials}
        response.should be_success
      end
    end

  end

  context "with no auth token" do
    describe "GET index" do
      it 'should return unauthorized' do
        get uri_for("/orders/R123456/line_items.json")
        last_response.status.should == 418
      end
    end

    describe "GET show" do
      before { order.stub_chain(:line_items, :scoped, :find => line_item) }

      it "should return unauthorized" do
        get uri_for("/orders/R123456/line_items/1.json")
        last_response.status.should == 418
      end
    end

    describe "POST create" do

      it "should return unauthorized" do
        post uri_for("/orders/R123456/line_items.json")
        last_response.status.should == 418
      end
    end

    describe "PUT update" do
      before { order.stub_chain(:line_items, :scoped, :find => line_item) }

      it "should return unauthorized" do
        put uri_for("/orders/R123456/line_items/1.json")
        last_response.status.should == 418
      end
    end
  end

  context "with bad auth token" do
    let(:credentials) { encode_credentials("foo") }

    describe "GET index" do
      it 'should return unauthorized' do
        get uri_for("/orders/R123456/line_items.json"), nil, {'HTTP_AUTHORIZATION' => credentials}
        last_response.status.should == 418
      end
    end

    describe "GET show" do
      before { order.stub_chain(:line_items, :scoped, :find => line_item) }

      it "should return unauthorized" do
        get uri_for("/orders/R123456/line_items/1.json"), nil, {'HTTP_AUTHORIZATION' => credentials}
        last_response.status.should == 418
      end
    end

    describe "POST create" do

      it "should return unauthorized" do
        post uri_for("/orders/R123456/line_items.json"), nil, {'HTTP_AUTHORIZATION' => credentials}
        last_response.status.should == 418
      end
    end

    describe "PUT update" do
      before { order.stub_chain(:line_items, :scoped, :find => line_item) }

      it "should return unauthorized" do
        put uri_for("/orders/R123456/line_items/1.json"), nil, {'HTTP_AUTHORIZATION' => credentials}
        last_response.status.should == 418
      end
    end
  end
end
