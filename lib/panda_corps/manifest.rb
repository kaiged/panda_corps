module PandaCorps
  class Manifest
    attr_reader :consumables, :productions

    def initialize
      @consumables = []
      @productions = []
    end

    def add_consumable(consumable, validation=nil)
      @consumables << Requirement.new(consumable, validation)
    end

    def add_production(production, validation=nil)
      @productions << Requirement.new(production, validation)
    end
  end
end