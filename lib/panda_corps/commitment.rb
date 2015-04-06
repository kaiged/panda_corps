module PandaCorps
  class Commitment
    attr_reader :type, :worker
    def initialize(type, worker)
      @type = type
      @worker = worker
    end
  end
end
