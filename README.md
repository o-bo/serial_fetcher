# SerialFetcher

Serial Fetcher provides a way to automatically fetch a list of resources from
the params hash.

The params must be passed to the `fetch` method with a `schema` describing the
associations between params and models.

A fetcher must be provided to the SerialFetcher through configuration.
By default there is an ActiveRecord fetcher that call `find` to the constantized
class name.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'serial_fetcher'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install serial_fetcher

## Usage

Suppose you have an url like :

    http://localhost:3000/users/1/blogs/5/posts/35/comments/3

The corresponding params are :

```ruby
params: {
  user_id: "1",
  blog_id: "5",
  post_id: "35",
  id: "3"
}
```

Now in your comments_controller.rb, you probably have something like :

```ruby
@user = User.find params[:user_id]
@blog = Blog.find params[:blog_id]
@post = Post.find params[:post_id]
@comment = User.find params[:id]
```

With SerialFetcher, you could just write :

```ruby
@store = SerialFetcher.fetch(params, id: :comment)
```

And then @store will be created with :

```ruby
@store = {
  user: User.find params[:user_id],
  blog: Blog.find params[:blog_id],
  post: Post.find params[:post_id],
  comment: Comment.find params[:id]
}
```
You must provide the resource associated to the :id param.
The script will parse all the params containing '_id', and try to fetch the
corresponding resources.

Particular case if your param is not named like the model :

```ruby
schema: {
  id: :comment,
  post_id: :article,
}

@store = SerialFetcher.fetch(params, schema)
```

And then @store will be created with :

```ruby
@store = {
  article: Article.find params[:post_id],
  comment: Comment.find params[:id]
}
```
You can provide your own fetcher in an initializer :

```ruby
SerialFetcher.configure |config|

  # If we define repositories for our models, with a
  # fetch_for_id method
  config.fetcher = ->(param_name, param) {
    begin
      klass_name = "#{param_name}_repository".camelize
      klass = klass_name.constantize
      klass.send(:fetch_for_id, param)
    rescue NameError
      # The repository does not exist for the given param
      nil
    end
  }
```

## TODO

Add a  fetch_adapter and pass the current context (current_user), then pass the
context to the fetcher ; it will allow the developer to test in the lambda if
the current user can access the requested resources.

```ruby
SerialFetcher.adapter(current_user: current_user).fetch(params, schema)
```
Example :

```ruby
config.fetcher = ->(param_name, param, context) {
  # ...
  if context[:current_user].cannot?(:show, post)
    return nil
  end
}
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/o-bo/serial_fetcher.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

