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
        move_requirement(consumable, parent, worker_instance)
      end
    end

    def move_requirements_to_parent(parent, worker_instance)
      worker_instance.manifest.productions.each do |production|
        if consumable = parent.manifest.consumables.find {|c| production.name == c.name }
          validate_requirement(worker_instance, consumable, parent)
        end
        move_requirement(production, worker_instance, parent)
      end
    end

    def move_requirement(requirement, from, to)
      raise RequirementError.no_key(requirement, from, to) unless from.products.has_key?(requirement.name)
      validate_requirement(from, requirement, to)
      to.products[requirement.name] = from.products[requirement.name]
    end

    def validate_requirement(from, requirement, to)
      item = from.products[requirement.name]
      raise RequirementError.bad_requirement(requirement, from, to, item) unless requirement.validates?(item)
    end

  end
end