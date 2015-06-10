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

    def product_getters
      @product_getters ||= productions.map { |p| p.name.to_sym } + consumables.map { |c| c.name.to_sym }
    end

    def product_setters
      @product_setters ||= productions.each_with_object({}) { |p, h| h["#{p.name}=".to_sym] = p.name }
    end
  end
end