module ApiResponserHelper
  def self.error_handling(code:nil,debug_message:nil,message:nil)
    Logger.new(STDOUT).fatal("Error with code #{code}. Debug message: #{debug_message}. Message: #{message}")
  end
end
