Gem::Specification.new do |spec|
  spec.name          = 'api_responser'
  spec.version       = '1.1'
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
  spec.files         = Dir[
    'app/helpers/**/*.rb',
    'app/views/**/*.erb',
    'lib/**/*.rb',
    'config/locales/*.yml',
    'readme.md',
    'LICENSE'
  ].select { |f| File.file?(f) }
  spec.homepage      = 'https://github.com/nmehdiyev/ApiResponser'
  spec.metadata      = { "source_code_uri" => "https://github.com/nmehdiyev/ApiResponser" }

  spec.require_paths = ["lib"]
  spec.required_ruby_version = '>= 3.0'

  spec.add_dependency 'rails', '>= 7.0'

  spec.add_development_dependency 'minitest', '~> 5.1'
  spec.add_development_dependency 'webrick', '~> 1.8'
end
