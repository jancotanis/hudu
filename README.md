# Hudu API

This is a wrapper for the Hudu rest API. You can see the API endpoints here https://www.zabbix.com/documentation/current/en/manual/api/reference/

Currently only the GET requests to get a list of hosts, host groups and problems are implemented.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'hudu'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install hudu

## Usage

Before you start making the requests to API provide the endpoint and api key using the configuration wrapping.

```ruby
require 'hudu'
require 'logger'

# use do block
Hudu.configure do |config|
  config.endpoint = ENV['HUDU_API_HOST'].downcase
  config.api_key = ENV['HUDU_API_KEY']
end

# or configure with options hash
client = Hudu.client({ logger: Logger.new(CLIENT_LOGGER) })
client.login

```

## Resources
### Authentication
```
# setup 
#
client.login
```
|Resource|API endpoint|Description|
|:--|:--|:--|
|.login| none |uses api_info to check if credentials are correct. Raises Hudu:AuthenticationError incase this fails|



### Data resources
Endpoint for data related requests 
```ruby

# list all asset layouts/fields for a company
assets = client.company_assets(client.companies.first.id)
assets.each do |asset|
  layout = client.asset_layout(asset.asset_layout_id)
  puts "#{layout.name}: '#{asset.name}'"
  puts "=================================================="
  asset.fields.each do |field|
    value = field.value || ''
    # trim value to first 40 characters
    puts " #{field.position.to_s.rjust(3)} #{field.label}: '#{value[0..40]}'"
  end
end
```

|Resource|API endpoint|
|:--|:--|
|.api_info                         | /api/v1/api_info|
|.activity_logs                    | /api/v1/activity_logs|
|.companies, :company(id)          | /api/v1/companies/{id}|
|.articles, :article(id)           | /api/v1/articles/{id}|
|.asset_layouts, :asset_layout(id) | /api/v1/asset_layouts/{id}|
|.assets, :asset(id)               | /api/v1/assets/{id}|
|.asset_passwords                  | /api/v1/asset_passwords/{id}|
|.folders, :folder(id)             | /api/v1/folders/{id}|
|.procedures, :procedure(id)       | /api/v1/procedures/{id}|
|.expirations                      | /api/v1/expirations|
|.websites, :website(id)           | /api/v1/websites/{id}|
|.relations                        | /api/v1/relations|
|.company_articles(id)             |/api/v1/companies/{id}/articles|
|.company_assets(id)               |/api/v1/companies/{id}/assets|
|.company_asset(id,asset_id)       |/api/v1/companies/{id}/assets/{asset_id}|


## Publishing

1. Update version in [version.rb](lib/hudu/version.rb).
2. Add release to [CHANGELOG.md](CHANGELOG.md)
3. Commit.
4. Test build.
```
> rake build

```
5. Release
```
> rake release

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jancotanis/hudu.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
