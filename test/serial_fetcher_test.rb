require 'test_helper'

class SerialFetcherTest < Minitest::Test


  def setup
    SerialFetcher.configure do |config|
      config.fetcher = ->(param_name, param) {
        {}
      }
    end
  end


  def test_that_it_has_a_version_number
    refute_nil ::SerialFetcher::VERSION
  end


  def test_it_raises_an_error_without_params
    begin
      SerialFetcher.fetch(nil, id: :resource)
      assert false, "Params are not null."
    rescue StandardError => e
      assert e.message == "You must provide a hash for params.", "Error message is #{e}"
    end
  end


  def test_it_raises_an_error_without_id_association
    begin
      SerialFetcher.fetch({id: "1"}, {model_id: :model})
      assert false, "Id is not null."
    rescue StandardError => e
      assert e.message == "You must provide the key id for the basic resource to be fetched.", "Error message is #{e}"
    end
  end


  def test_it_raises_an_error_without_fetcher
    SerialFetcher.configure do |config|
      config.fetcher = nil
    end

    begin
      SerialFetcher.fetch({id: "1"}, {id: :model})
      assert false, "Fetcher is not null."
    rescue StandardError => e
      assert e.message == "You must provide a fetcher method.", "Error message is #{e}"
    end
  end


  def test_with_simple_schema
    params = {user_id: "1", blog_id: "2", id: "3"}
    store = SerialFetcher.fetch(params, id: :post)
    assert store == {user: {}, blog: {}, post: {}}
  end


  def test_with_complete_schema
    params = {user_id: "1", blog_id: "2", id: "3"}
    store = SerialFetcher.fetch(params, {id: :post, blog_id: :blog, user_id: :user})
    assert store == {user: {}, blog: {}, post: {}}
  end


  def test_with_particular_case
    params = {user_id: "1", blog_id: "2", id: "3"}
    store = SerialFetcher.fetch(params, { id: :post, user_id: :author})
    assert store == {author: {}, blog: {}, post: {}}
  end
end
