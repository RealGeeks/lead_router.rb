module LeadRouter

  # All possible exceptions raised by the LeadRouter::Client will be an instance
  # of this class
  #
  # Use 'original_exception' method to access the original exception object , or
  # just 'to_s' to display a nice error message
  #
  # If the error was an invalid HTTP status code, 'http_code' and 'http_body' methods
  # will be available (they return 0 and "" otherwise)
  class Exception < RuntimeError

    attr_accessor :original_exception

    def initialize(exception)
      @original_exception = exception
    end

    def to_s
      return "#{original_exception.to_s}: HTTP status #{http_code} with body #{http_body}" unless http_code == 0
      original_exception.to_s
    end

    def http_code
      original_exception.respond_to?(:http_code) ? original_exception.http_code : 0
    end

    def http_body
      original_exception.respond_to?(:http_body) ? original_exception.http_body : ""
    end

  end

end
