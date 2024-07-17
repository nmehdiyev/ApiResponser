Gem::Specification.new do |spec|
  spec.name          = 'api_responser'
  spec.version       = '1.0.0'
  spec.authors       = ['Nazim Mehdiyev']
  spec.email         = ['nazim@mehdiyev.me']
  spec.licenses      = ['MIT']
  spec.summary       = %q{A gem to standardize API responses in Rails applications}
  spec.description   = %q{
    The api_responser gem provides a standardized way to handle API responses in a Rails application. 
    It includes methods for rendering success and error responses, making it easier to manage and maintain 
    consistent response structures across your application. The gem leverages I18n for localization, allowing 
    dynamic translation of response messages based on method names.
  }
  spec.files         = Dir['app/helpers/*','app/views/**/*', 'lib/**/*', 'config/locales/*.yml', 'README.md', 'LICENSE']
  spec.homepage      = 'https://github.com/nmehdiyev/ApiResponser'
  spec.metadata      = { "source_code_uri" => "https://github.com/nmehdiyev/ApiResponser" }

  spec.require_paths = ["lib"]

  spec.add_dependency 'rails', '~> 6.0'

  spec.add_development_dependency 'minitest'
  spec.add_development_dependency 'webrick'
end
