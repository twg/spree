require 'spec_helper.rb'

describe Api::InventoryUnitsController do
  include Rack::Test::Methods

  def app
    Rails.application
  end

  let(:order) { Order.new }
  let(:inventory_unit) { mock_model(InventoryUnit, :update_attributes => true) }
  let(:user) { mock_model(User, :has_role? => true, :valid_for_authentication? => true, :after_token_authentication => nil) }

  before do
    Order.stub :find_by_param! => order
    User.stub(:find_for_token_authentication).with(:auth_token => VALID_TOKEN).and_return user
    User.stub(:find_for_token_authentication).with(:auth_token => "foo").and_return nil
    InventoryUnit.stub :find => inventory_unit
  end

  context "when valid auth token" do
    let(:credentials) { encode_credentials(VALID_TOKEN) }

    describe "GET index" do

      it 'should GET list of Inventory Units' do
        get uri_for("/orders/R123456/inventory_units.json"), nil, {'HTTP_AUTHORIZATION' => credentials}
        response.should be_success
      end
    end

    describe "GET show" do

      it "should GET a single Inventory Unit" do
        get uri_for("/orders/R123456/inventory_units/1.json"), nil, {'HTTP_AUTHORIZATION' => credentials}
        response.should be_success
      end
    end

    describe "POST create" do
      it "should POST new data to Inventory Units" do
        post uri_for("/orders/R123456/inventory_units.json"), nil, {'HTTP_AUTHORIZATION' => credentials}
        response.should be_success
      end
    end

    describe "PUT update" do
      before { order.stub_chain(:inventory_units, :scoped, :find => inventory_unit) }

      it "should PUT updated data into Inventory Units" do
        put uri_for("/orders/R123456/inventory_units/1.json"), {:text => {:id => 1, :foo => "text"}}, {'HTTP_AUTHORIZATION' => credentials}
        response.should be_success
      end
    end

  end

  context "when no auth token" do

    describe "GET index" do
      it 'should return unauthorized' do
        get uri_for("/orders/R123456/inventory_units.json"), nil
        last_response.status.should == 418
      end
    end

    describe "GET show" do
      before { order.stub_chain(:inventory_units, :scoped, :find => inventory_unit) }

      it "should return unauthorized" do
        get uri_for("/orders/R123456/inventory_units/1.json"), nil
        last_response.status.should == 418
      end
    end

    describe "POST create" do
      it "should return unauthorized" do
        post uri_for("/orders/R123456/inventory_units.json"), {:text => {:foo => "text"}}
        last_response.status.should == 418
      end
    end

    describe "PUT update" do
      before { order.stub_chain(:inventory_units, :scoped, :find => inventory_unit) }

      it "should return unauthorized" do
        put uri_for("/orders/R123456/inventory_units/1.json"), {:text => {:id => 1, :foo => "text"}}
        last_response.status.should == 418
      end
    end
  end

  context "when bad auth token" do
    let(:credentials) { encode_credentials("foo") }

    describe "GET index" do
      it 'should return unauthorized' do
        get uri_for("/orders/R123456/inventory_units.json"), nil, {'HTTP_AUTHORIZATION' => credentials}
        last_response.status.should == 418
      end
    end

    describe "GET show" do
      before { order.stub_chain(:inventory_units, :scoped, :find => inventory_unit) }

      it "should return unauthorized" do
        get uri_for("/orders/R123456/inventory_units/1.json"), nil, {'HTTP_AUTHORIZATION' => credentials}
        last_response.status.should == 418
      end
    end

    describe "POST create" do
      it "should return unauthorized" do
        post uri_for("/orders/R123456/inventory_units.json"), {:text => {:foo => "text"}}, {'HTTP_AUTHORIZATION' => credentials}
        last_response.status.should == 418
      end
    end

    describe "PUT update" do
      before { order.stub_chain(:inventory_units, :scoped, :find => inventory_unit) }

      it "should return unauthorized" do
        put uri_for("/orders/R123456/inventory_units/1.json"), {:text => {:id => 1, :foo => "text"}}, {'HTTP_AUTHORIZATION' => credentials}
        last_response.status.should == 418
      end
    end
  end

end
