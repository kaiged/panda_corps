module PandaCorps
  class Requirement
    attr_reader :name, :validation
    def initialize(name, validation = nil)
      @name = name
      @validation = validation
    end

    def validates?(value)
      return true if validation.nil?
      return false if validation == :not_nil && value.nil?
      return value.is_a?(validation) if validation.is_a?(Class)
      return false
    end
  end
end