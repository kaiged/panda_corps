module PandaCorps
  class JobDescription
    attr_reader :before_commitments, :work_commitments, :after_commitments

    def initialize(worker)
      @work_commitments = []
      @before_commitments = []
      @after_commitments = []
      @worker = worker
    end

    def work(opt, &block)
      add_work(@work_commitments, opt, &block)
    end

    def before(opt, &block)
      add_work(@before_commitments, opt, &block)
    end

    def after(opt, &block)
      add_work(@after_commitments, opt, &block)
    end

    private

    def add_work(collection, opt, &block)
      if block
        name = opt.nil? ? opt : opt.to_s
        collection << Commitment.new(:work, block, @worker, name)
      elsif opt && opt.ancestors.include?(Worker)
        collection << Commitment.new(:delegate, opt, @worker, nil)
      else
        raise "Invalid work option #{opt.to_s}"
      end
    end
  end
end
