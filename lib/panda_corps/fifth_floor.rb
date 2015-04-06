module PandaCorps
  class FifthFloor
    attr_accessor :manager

    #declarative
    def work(&block)
      @commitments << Commitment.new(:work, block)
    end

    def delegate_to(worker)
      @commitments << Commitment.new(:delegate, worker)
    end

    def commitments
      @commitments = []
      job_description
      @commitments
    end

    def i_consume(*consumables)
      @consumables += consumables
    end

    def i_produce(*productions)
      @productions += productions
    end

    def call_manifest
      @consumables = []
      @productions = []
      public_send(:manifest) if respond_to?(:manifest)
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

    %w(debug info warning error fatal).each do |method_name|
      define_method(method_name) do |message|
        manager.public_send("handle_#{method_name}", message, self)
      end
    end

    def handle_unhandled_exception(args)
      public_send(:on_unhandled_exception, args) if respond_to?(:on_unhandled_exception)
    end

  private

    def products
      @products ||= {}
    end
  end
end
