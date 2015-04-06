module PandaCorps
  class Executive < SeventhFloor
    def on_work_commitment(commitment)
      commitment.worker.call
    end

    def on_delegate_commitment(parent, commitment)
      worker_instance = commitment.worker.new

      worker_instance.consumables.each do |consumable|
        worker_instance.produce consumable, parent.consume(consumable)
      end

      manage(worker_instance)

      worker_instance.productions.each do |production|
        parent.produce production, worker_instance.consume(production)
      end
    end
  end
end