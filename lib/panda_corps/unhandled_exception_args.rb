module PandaCorps
  class UnhandledExceptionArgs
    attr_reader :e

    def initialize(exception)
      @e = exception
      @fatal = true
    end

    def fatal= value
      @fatal = value
    end

    def fatal?
      @fatal
    end
  end
end