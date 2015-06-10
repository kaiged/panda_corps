module PandaCorps
  class Commitment
    attr_reader :type, :work_unit, :worker, :name

    def run?
      @run == true
    end

    def mark_run
      @run = true
    end

    def initialize(type, work_unit, worker, name)
      @type = type
      @work_unit = work_unit
      @worker = worker
      @name = name
    end
  end
end
