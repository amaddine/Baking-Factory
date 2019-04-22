require "test_helper"

describe ItemPriceController do
  it "should get index" do
    get item_price_index_url
    value(response).must_be :success?
  end

  it "should get show" do
    get item_price_show_url
    value(response).must_be :success?
  end

  it "should get new" do
    get item_price_new_url
    value(response).must_be :success?
  end

  it "should get edit" do
    get item_price_edit_url
    value(response).must_be :success?
  end

  it "should get create" do
    get item_price_create_url
    value(response).must_be :success?
  end

  it "should get update" do
    get item_price_update_url
    value(response).must_be :success?
  end

  it "should get destroy" do
    get item_price_destroy_url
    value(response).must_be :success?
  end

end
