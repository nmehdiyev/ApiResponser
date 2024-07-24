# ApiResponser

#### Overview
The **api_responser** gem is designed to streamline the process of handling API responses in your Rails application. It provides a simple and consistent way to render success and error messages, ensuring your API responses are always well-structured and easy to manage.

#### Key Features
- Standardized Responses: Simplify the way you handle API responses by using a set of predefined methods for success and error messages.
- Localization Support: Leverage the power of I18n to dynamically translate response messages, making your API more versatile and user-friendly for a global audience.
- Ease of Use: With intuitive method names and straightforward implementation, integrating api_responser into your Rails application is quick and hassle-free.
- Maintenance: Reduce the effort required to maintain consistent response structures across your application, making your codebase cleaner and more maintainable.

A gem to standardize API responses in Rails applications.

All methods return JSON and status.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'api_responser'
```

And then execute:

```bash
bundle install
```

Or install it yourself as:

```bash
gem install api_responser
```

## Usage
### Initialization
```ruby
class ApplicationController < ActionController::Base
  include ApiResponser
end
```

## Success Response list
#### List of Items
The *records* argument is required and should be an **Array**. The *records_count* argument is an **Integer** and is optional.\
If *records_count* is not provided, the count will be calculated from the size of the *records* array
```ruby
def record_index(records, records_count = nil)
```
#### Show Item
The *records* argument should be a **Hash**. It should contain only one model 
```ruby
def record_show(records)
```
#### Item Create / Item Update / Item Delete
*No arguments* are required
```ruby
def record_created
```
```ruby
def record_updated
```
```ruby
def record_deleted
```




## Error Response list
#### Page Not Found / Record Not Found / Method Not Allowed / Not Acceptable / Conflict / Gone / Unsupported Media Type / Too Many Requests / Not Implemented / Service Unavailable
*No arguments* are required

```ruby
def page_not_found
```
```ruby
def record_not_found
```
```ruby
def method_not_allowed
```
```ruby
def not_acceptable
```
```ruby
def conflict
```
```ruby
def gone
```
```ruby
def unsupported_media_type
```
```ruby
def too_many_requests
```
```ruby
def not_implemented
```
```ruby
def service_unavailable
```

#### Record Not Created / Record Not Updated / Record Not Deleted
The *message* argument is required, while the *debug_message* argument is optional.\
The *report* argument is optional and is useful if you would like to handle *debug_message*.\
The *message* argument is used to output a message in the JSON response, whereas *debug_message* is useful for providing the real reason for the error (if *report* is **true**). 

```ruby
def record_not_created(message, debug_message = "", report:false)
```
```ruby
def record_not_updated(message, debug_message = "", report:false)
```
```ruby
def record_not_deleted(message, debug_message = "", report:false)
```

#### Bad request / Unauthorized / Forbidden / Internal Server Error
The *debug_message* argument is optional.\
The *report* argument is optional and is useful if you would like to handle *debug_message*.\
The *debug_message* is useful for providing the real reason for the error (if *report* is **true**). 
The *message* argument is optional and is useful if you would like to provide your custom message. For example "Incorrect login or password"

```ruby
def bad_request(debug_message = "", report:false)
```
```ruby
def unauthorized(debug_message = "", message:nil, report:false)
```
```ruby
def forbidden(debug_message = "", report:false)
```
```ruby
def internal_server_error(debug_message = "", report:false)
```


## Customizing Response Templates
You can modify the success and error response templates.
Templates should be located in **app/views/api_responser/**

The default templates are:
#### success.json.erb
``` ruby
"data":{
  "status": "success",
  "code": <%= @code %>,
  "message": "<%= @message %>",
  "records": <%= @records.to_json %>,
  "records_count": <%= @records_count %>
}
```
####  error.json.erb
``` ruby
"data":{
  "status": "error",
  "code": <%= @code %>,
  "message": "<%= @message %>"
}
```

## Customizing Error Handling
The gem provides a default error handler in **ApiResponserHelper**:
``` ruby
module ApiResponserHelper
  def self.error_handling(code: nil, debug_message: nil, message: nil)
    Logger.new(STDOUT).fatal("Error with code #{code}. Debug message: #{debug_message}. Message: #{message}")
  end
end
```
You can customize this method to handle errors in a way that suits your application's requirements. For example, you might want to log errors to a file or send notifications to an external service.
Helper should be located in **app/helpers/app_responser_helper.rb**


## Localization
**ApiResponser** uses I18n for localization.

Default localization located in config/locale/en.yml



## Example
```ruby

class ApplicationController < ActionController::Base
  #include ApiResponser in ApplicationController
  include ApiResponser
end

class SomeController < ApplicationController
  before_action do
    set_model_variable("ModelName")
  end  
  before_action :find, only: [:show, :update, :destroy]

  def index
    itemList = @modelName.all
    render record_index(itemList)

    # could be using with counter for pagination
    itemList = @modelName.where(:name => "value")
    render record_index(itemList.limit(5), itemList.count)
  end

  def show
    render record_show(@obj)
  end

  def create
    item = @modelName.new(model_params)
    if item.save
      render record_created
    else
      render record_not_created(item.errors, report:true)
    end
  end

  def update
    if @obj.update(model_params)
      render record_updated
    else
      render record_not_updated(@obj.errors, report:true)
    end
  end

  def destroy
    if @obj.destroy
      render record_deleted
    else
      render record_not_deleted(@obj.errors, report:true)
    end
  end


  private
  def find
    @obj = @modelName.find_by(:id => params[:id])
    unless @obj
      render record_not_found
    end
  end

  def model_params
    params.require(:model).permit(:name)
  end  

  def set_model_variable modelName
    @modelName = modelName.constantize
  end
end

```

[![Buy me a coffee](https://img.buymeacoffee.com/button-api/?text=Buy%20me%20a%20coffee&emoji=&slug=nmehdiyev&button_colour=FFDD00&font_colour=000000&font_family=Cookie&outline_colour=000000&coffee_colour=ffffff)](https://www.buymeacoffee.com/nmehdiyev)



## Contributing

Pull requests are welcome. For major changes, please open an issue first
to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License

[MIT](https://choosealicense.com/licenses/mit/)