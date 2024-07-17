require 'rails'

module ApiResponser
  class Railtie < Rails::Railtie
    I18n.load_path += Dir[File.join(File.dirname(__FILE__), '../../config/locales/*.yml')]

    initializer 'api_responser.add_view_paths' do |app|
      # Adding the gem's views directory to the view paths
      app.config.paths['app/views'].unshift File.expand_path('../../../app/views', __FILE__)
    end

    initializer 'api_responser.include_helpers' do
      ActiveSupport.on_load(:action_controller_base) do
        require File.expand_path('../../../app/helpers/api_responser_helper', __FILE__)
        include ApiResponserHelper
      end
    end
  end
end
