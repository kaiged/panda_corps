module PandaCorps
  class FifthFloor
    attr_accessor :manager, :parent

    #declarative
    def work(&block)
      @commitments << Commitment.new(:work, block, self)
    end

    def delegate_to(work_unit)
      @commitments << Commitment.new(:delegate, work_unit, self)
    end

    def commitments
      @commitments = []
      job_description
      @commitments
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
    def consume(product)
      products[product]
    end

    def produce(product, value)
      products[product] = value
    end

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

    def title(delimeter = '::')
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

    private

    def call_manifest
      @consumables = []
      @productions = []
      public_send(:manifest) if respond_to?(:manifest)
    end
  end
end
