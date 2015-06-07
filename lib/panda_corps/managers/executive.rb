module PandaCorps
  class Executive < Manager
    def on_work_commitment(commitment)
      commitment.work_unit.call
    end

    def on_delegate_commitment(parent, worker_instance)
      move_requirements_to_worker(parent, worker_instance)
      manage_worker(worker_instance)
      move_requirements_to_parent(parent, worker_instance)
    end

    private

    def move_requirements_to_worker(parent, worker_instance)
      worker_instance.manifest.consumables.each do |consumable|
        move_requirement(consumable, parent, worker_instance, worker_instance)
      end
    end

    def move_requirements_to_parent(parent, worker_instance)
      worker_instance.manifest.productions.each do |production|
        move_requirement(production, worker_instance, parent, worker_instance)
      end
    end

    def move_requirement(requirement, from, to, worker_instance)
      notify_bad_job(RequirementError.no_key(requirement, from, to), worker_instance) unless from.products.has_key?(requirement.name)
      item = from.products[requirement.name]
      notify_bad_job(RequirementError.bad_requirement(requirement, from, to, item), worker_instance) unless requirement.validates?(item)
      to.products[requirement.name] = item
    end

    def notify_bad_job(error, worker)
      handle_bad_job(error, worker)
      raise error
    end
  end
end