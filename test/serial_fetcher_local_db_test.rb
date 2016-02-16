require 'test_helper'

class SerialFetcherLocalDbTest < Minitest::Test


  def setup
    local_db = {
      store: [{id: "6", name: "Store"}],
      user: [{id: "1", name: "John"}],
      blog: [{id: "2", name: "Amazing Blog"}],
      post: [{id: "3", title: "Awesome Post"}],
      article: [{id: "4", title: "Awesome Article"}]
    }
    basic_fetcher = ->(param_name, param) {
      if local_db[param_name.to_sym]
        local_db[param_name.to_sym].find {|item| item[:id] == param}
      else
        nil
      end
    }

    SerialFetcher.configure do |config|
      config.fetcher = basic_fetcher
    end
  end


  def test_with_simple_schema
    params = {user_id: "1", blog_id: "2", id: "3"}
    store = SerialFetcher.fetch(params, id: :post)
    assert store[:user] == {id: "1", name: "John"}
    assert store[:blog] == {id: "2", name: "Amazing Blog"}
    assert store[:post] == {id: "3", title: "Awesome Post"}
  end


  def test_with_complete_schema
    params = {user_id: "1", blog_id: "2", id: "3"}
    store = SerialFetcher.fetch(params, {id: :post, blog_id: :blog, user_id: :user})
    assert store[:user] == {id: "1", name: "John"}
    assert store[:blog] == {id: "2", name: "Amazing Blog"}
    assert store[:post] == {id: "3", title: "Awesome Post"}
  end


  def test_with_unknown_params
    params = {thing_id: "10", user_id: "1", blog_id: "2", id: "3"}
    store = SerialFetcher.fetch(params, id: :post)
    assert store[:user] == {id: "1", name: "John"}
    assert store[:blog] == {id: "2", name: "Amazing Blog"}
    assert store[:post] == {id: "3", title: "Awesome Post"}
    assert store[:thing] == nil
  end


  def test_with_bad_schema_key
    params = {thing_id: "10", user_id: "1", blog_id: "2", id: "3"}
    store = SerialFetcher.fetch(params, {id: :post, thing_id: :thing})
    assert store[:user] == {id: "1", name: "John"}
    assert store[:blog] == {id: "2", name: "Amazing Blog"}
    assert store[:post] == {id: "3", title: "Awesome Post"}
    assert store[:thing] == nil
  end


  def test_with_particular_case
    params = {site_id: "6", user_id: "1", blog_id: "2", id: "3"}
    store = SerialFetcher.fetch(params, { id: :post, site_id: :store})
    assert store[:user] == {id: "1", name: "John"}
    assert store[:blog] == {id: "2", name: "Amazing Blog"}
    assert store[:post] == {id: "3", title: "Awesome Post"}
    assert store[:store] == {id: "6", name: "Store"}
  end
end
