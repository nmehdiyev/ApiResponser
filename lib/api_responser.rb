require 'rails'

require_relative 'api_responser/railtie' if defined?(Rails)
module ApiResponser
  # Success responses
  def record_index(records, records_count = nil)
    success_render(code: 200, message: i18n_message(__method__, status:"success"), records: records, records_count: records_count)
  end

  def record_show(records)
    success_render(code: 200, message: i18n_message(__method__, status:"success"), records: records)
  end

  def record_created
    api_success(code: 201)
  end

  def record_updated
    api_success(code: 204)
  end

  def record_deleted
    api_success(code: 204)
  end

  # Error responses
  def page_not_found
    error_render(code: 404, message: i18n_message(__method__, status:"error"))
  end

  def record_not_found
    error_render(code: 404, message: i18n_message(__method__, status:"error"))
  end

  def record_not_created(message, debug_message = "", report:false)
    error_render(code: 422, message: i18n_message(__method__, status:"error", message: message), debug_message: debug_message, report:report)
  end

  def record_not_updated(message, debug_message = "", report:false)
    error_render(code: 422, message: i18n_message(__method__, status:"error", message: message), debug_message: debug_message, report:report)
  end

  def record_not_deleted(message, debug_message = "", report:false)
    error_render(code: 500, message: i18n_message(__method__, status:"error", message: message), debug_message: debug_message, report:report)
  end

  def bad_request(debug_message = "", report:false)
    error_render(code: 400, message: i18n_message(__method__, status:"error"), debug_message: debug_message, report:report)
  end

  def unauthorized(debug_message = "", report:false)
    error_render(code: 401, message: i18n_message(__method__, status:"error"), debug_message: debug_message, report:report)
  end

  def forbidden(debug_message = "", report:false)
    error_render(code: 403, message: i18n_message(__method__, status:"error"), debug_message: debug_message, report:report)
  end

  def internal_server_error(debug_message = "", report:false)
    error_render(code: 500, message: i18n_message(__method__, status:"error"), debug_message: debug_message, report:report)
  end

  def method_not_allowed
    error_render(code: 405, message: i18n_message(__method__, status:"error"))
  end

  def not_acceptable
    error_render(code: 406, message: i18n_message(__method__, status:"error"))
  end

  def conflict
    error_render(code: 409, message: i18n_message(__method__, status:"error"))
  end

  def gone
    error_render(code: 410, message: i18n_message(__method__, status:"error"))
  end

  def unsupported_media_type
    error_render(code: 415, message: i18n_message(__method__, status:"error"))
  end

  def too_many_requests
    error_render(code: 429, message: i18n_message(__method__, status:"error"))
  end


  def not_implemented
    error_render(code: 501, message: i18n_message(__method__, status:"error"))
  end

  def service_unavailable
    error_render(code: 503, message: i18n_message(__method__, status:"error"))
  end

  private

  def api_success(code: 200)
    {status: code}
  end


  def success_render(code: 200, message: "", records: nil, records_count: nil)
    @code = code
    @message = message
    @records = records
    @records_count = determine_records_count(records, records_count)
    {json:ERB.new(file_read("success")).result(binding), status: code}
  end

  def error_render(code: 500, message: "", debug_message: "", report: false)
    @code = code
    @message = message
    error_handling(code: code, message: message, debug_message: debug_message) if report == true
    {json: ERB.new(file_read("error")).result(binding), status: code}
  end

  def file_read(type = "error")
    if defined?(Rails) && Rails.root
      app_view_path = Rails.root.join('app', 'views', 'api_responser', "#{type}.json.erb")
    else
      app_view_path = File.join(Dir.pwd, 'app', 'views', 'api_responser', "#{type}.json.erb")
    end

    gem_view_path = File.expand_path("../../app/views/api_responser/#{type}.json.erb", __FILE__)

    File.exist?(app_view_path) ? File.read(app_view_path) : File.read(gem_view_path)
  end

  def i18n_message(method_name, status:"error", message: nil)
    message = message.full_messages.join(', ') if message.is_a?(ActiveModel::Errors)
    message = message.join(', ') if message.is_a?(Array)
    I18n.t("api_responser.#{status}.#{method_name}", message: message)
  end

  def error_handling(code:, message:, debug_message:)
    ApiResponserHelper.error_handling(:code => code, :message => message, :debug_message => debug_message)
  end

  def determine_records_count(records, records_count)
    records_count || ((records.is_a?(ActiveRecord::Relation) || (records.is_a?(Array))) ? records.count : (records.nil? || records.blank? ? 0 : 1))
  end
end
