module PandaCorps
  class UnhandledException < StandardError
    attr_reader :internal_exception

    def initialize(internal_exception)
      @internal_exception = internal_exception
      @suppress = false
    end

    def suppress?
      @suppress
    end

    def suppress!
      @suppress = true
    end
  end
end