module PandaCorps
  class Worker
    attr_accessor :manager, :parent

    #declarative
    def work(name=nil, &block)
      staged_commitments << Commitment.new(:work, block, self, name)
    end

    def delegate_to(work_unit)
      staged_commitments << Commitment.new(:delegate, work_unit, self, nil)
    end

    def commitments
      @staged_commitments = []
      job_description
      staged_commitments
    end

    def i_consume(consumable, validation = nil)
      @consumables << Requirement.new(consumable, validation)
    end

    def i_produce(production, validation = nil)
      @productions << Requirement.new(production, validation)
    end

    def consumables
      call_manifest
      @consumables
    end

    def productions
      call_manifest
      @productions
    end

    #run-time
    %w(debug info warning error).each do |method_name|
      handle_method_name = "handle_#{method_name}"
      define_method(method_name) do |message|
        manager.public_send(handle_method_name, message, self)
        public_send(handle_method_name, message, self)
      end

      define_method(handle_method_name) do |message, worker|
        on_method_name = "on_#{method_name}"
        public_send(on_method_name, message, worker) if respond_to?(on_method_name)
        parent.public_send(handle_method_name, message, worker) unless parent.nil?
      end
    end

    %w(start finish accomplished).each do |method_name|
      handle_method_name = "handle_#{method_name}"
      define_method(handle_method_name) do
        on_method_name = "on_#{method_name}"
        public_send(on_method_name) if respond_to?(on_method_name)
      end
    end

    def handle_exception(support, worker)
      on_exception(support, worker) if respond_to?(:on_exception)
      parent.handle_exception(support, worker) unless parent.nil?
    end

    def name
      self.class.name
    end

    def title(delimeter = '~>')
      current_parent = parent
      names = [name]
      until current_parent.nil? do
        names << current_parent.name
        current_parent = current_parent.parent
      end
      names.reverse.join(delimeter)
    end

    def products
      @products ||= {}
    end

    def method_missing(method_name, *arguments, &block)
      if product_getters.include?(method_name) && arguments.count == 0 && !block_given?
        return consume(method_name)
      end

      if product_setters.keys.include?(method_name) && arguments.count == 1 && !block_given?
        return produce(product_setters[method_name], arguments.first)
      end

      super
    end

    def public_methods(regular = true)
      super(regular) + product_getters + product_setters.keys
    end

    def methods(regular = true)
      super(regular) + product_getters + product_setters.keys
    end

    EXPLICIT_METHOD_CHECKS = [:manifest]
    def respond_to?(method_name, include_private = false)
      return super(method_name) if EXPLICIT_METHOD_CHECKS.include?(method_name)
      return true if super(method_name, include_private)

      return true if product_getters.include? method_name
      return true if product_setters.keys.include? method_name
      return false
    end

    def product_getters
      @product_getters ||= productions.map { |p| p.name.to_sym } + consumables.map { |c| c.name.to_sym }
    end

    def product_setters
      return @product_setters unless @product_setters.nil?
      @product_setters = {}
      productions.each { |p| @product_setters["#{p.name}=".to_sym] = p.name }
      @product_setters
    end

    private

    def consume(product)
      products[product]
    end

    def produce(product, value)
      products[product] = value
    end

    def call_manifest
      @consumables = []
      @productions = []
      public_send(:manifest) if respond_to?(:manifest)
    end

    def staged_commitments
      @staged_commitments ||= []
    end
  end
end
