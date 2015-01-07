# TenderHash

Map hashes with style. 

[![Build Status](https://travis-ci.org/rodrei/tender_hash.svg?branch=master)](https://travis-ci.org/rodrei/tender_hash)

## Installation

Add this line to your application's Gemfile:

    gem 'tender_hash'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tender_hash

## Usage

An empty set of rules will filter all keys returning an empty hash.

```ruby
TenderHash.map( { name: 'Rodrigo', age: 27 } )
```

The `key` method will cause the mapper to keep the specified key without
making any changes.

```ruby
TenderHash.map( { name: 'Rodrigo', age: 27 } ) do
  key :name
end

# => { name: 'Rodrigo' }
```

The `map_key` methods allows to define mappings for the hash keys.

```ruby
TenderHash.map( { name: 'Rodrigo', age: 27 } ) do
  map_key :name, :first_name
end

# => { first_name: 'Rodrigo' }
```

The `key` and `map_key` methods accept a `default` option. If the input hash
doesn't have the key defined or if it's value is `nil`, then the default value
will be set for that key on the returned hash.

```ruby
TenderHash.map( { name: 'Rodrigo', age: 27 } ) do
  map_key :name, :first_name, default: 'John Doe'
  key :height, default: 1.90
end

# => { first_name: 'Rodrigo', height: 1.90 }
```

The `key` and `map_key` methods also accept a `cast_to` option. The
possible alternatives are: `:integer`, `:string`, `:boolean` and any object that responds to `#call`.

```ruby
TenderHash.map( { name: 'Rodrigo', age: 27, logged_in: 'false' } ) do
  key :age,       cast_to: :string
  key :logged_in, cast_to: :boolean
  key :name,      cast_to: -> (v) { v.upcase }
end

# => { age: '27', looged_in: false, name: 'RODRIGO' }
```

The `scope` method allows to nest a hash within a key.

```ruby
TenderHash.map( { name: 'Rodrigo', age: 27, logged_in: 'false' } ) do
  scope :personal_info do
    map_key :name, :first_name
    key :age
  end

  key :logged_in
end

# => {
#       personal_info: {
#         first_name: 'Rodrigo',
#         age: 27
#       },
#       logged_in: 'false'
#    }
```

A good use case for this gem is to map the `ENV` hash into a more
readable and usable hash.

```ruby
TenderHash.map(ENV) do
  map_key 'EMAIL_NOTIFICATIONS', :send_email_notifications, cast_to: :boolean, default: true
  map_key 'MAPS_API_AUTH_TOKEN', :api_auth_token

  scope :database do
    map_key 'POSTGRES_URL',      :url, default: 'localhost'
    map_key 'PORT',              :port, cast_to: :integer, default: 5432
  end
end

# => {
#       send_email_notifications: true,
#       api_auth_token: 'super-secret',
#       database: {
#         url: 'localhost',
#         port: 5432
#       }
#    }
```

## Contributing

1. Fork it ( https://github.com/rodrei/tender_hash/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
