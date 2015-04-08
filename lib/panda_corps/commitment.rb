module PandaCorps
  class Commitment
    attr_reader :type, :work_unit, :worker
    def initialize(type, work_unit, worker)
      @type = type
      @work_unit = work_unit
      @worker = worker
    end
  end
end
