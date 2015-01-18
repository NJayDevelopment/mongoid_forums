require 'sanitize'

# This is exists so formatters can access it if it so pleases them.
module MongoidForums
  class Sanitizer
    def self.sanitize(text)
      Sanitize.clean(text, Sanitize::Config::BASIC)
    end
  end
end
