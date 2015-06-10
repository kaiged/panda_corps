module PandaCorps
  class Worker
    attr_accessor :manager, :parent

    def manifest
      @manifest ||= Manifest.new
    end

    def job_description
      @job_description ||= JobDescription.new(self)
    end

    def work(opt=nil, &block)
      job_description.work(opt, &block)
    end

    def before(opt=nil, &block)
      job_description.before(opt, &block)
    end

    def after(opt=nil, &block)
      job_description.after(opt, &block)
    end

    def consume(consumable, validation = nil)
      manifest.add_consumable consumable, validation
    end

    def produce(production, validation = nil)
      manifest.add_production production, validation
    end

    %w(debug info warning error).each do |method_name|
      handle_method_name = "handle_#{method_name}"
      define_method(method_name) do |message, opts = {}|
        manager.public_send(handle_method_name, message, opts, self)
        public_send(handle_method_name, message, opts, self)
      end

      define_method(handle_method_name) do |message, opts, worker|
        on_method_name = "on_#{method_name}"
        public_send(on_method_name, message, opts, worker) if respond_to?(on_method_name)
        parent.public_send(handle_method_name, message, opts, worker) unless parent.nil?
      end
    end

    %w(start finish accomplished).each do |method_name|
      handle_method_name = "handle_#{method_name}"
      define_method(handle_method_name) do
        on_method_name = "on_#{method_name}"
        public_send(on_method_name) if respond_to?(on_method_name)
      end
    end

    def name
      self.class.name
    end

    def title(delimeter = "~>")
      current_parent = parent
      names = [name]
      until current_parent.nil? do
        names << current_parent.name
        current_parent = current_parent.parent
      end
      names.reverse.join(delimeter)
    end

    def method_missing(method_name, *arguments, &block)
      if manifest.product_getters.include?(method_name) && arguments.count == 0 && !block_given?
        return self.products[method_name]
      end

      if manifest.product_setters.keys.include?(method_name) && arguments.count == 1 && !block_given?
        return products[manifest.product_setters[method_name]] = arguments.first
      end

      super
    end

    def public_methods(regular = true)
      super(regular) + manifest.product_getters + manifest.product_setters.keys
    end

    def methods(regular = true)
      super(regular) + manifest.product_getters + manifest.product_setters.keys
    end

    EXPLICIT_METHOD_CHECKS = [:manifest]
    def respond_to?(method_name, include_private = false)
      return super(method_name) if EXPLICIT_METHOD_CHECKS.include?(method_name)
      return true if super(method_name, include_private)

      return true if manifest.product_getters.include? method_name
      return true if manifest.product_setters.keys.include? method_name
      return false
    end

    def products
      @products ||= {}
    end

    private
  end
end
