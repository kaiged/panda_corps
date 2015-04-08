module PandaCorps
  class RequirementError < StandardError
    def self.no_key(requirement, from, to)
      message = "#{to.name} required #{requirement.name} from #{from.name}, but it wasn't provided."
      RequirementError.new(message)
    end

    def self.bad_requirement(requirement, from, to, item)
      message = "#{to.name} required #{requirement.name} from #{from.name} as a #{requirement.validation}, but is a #{item.class.name}"
      RequirementError.new(message)
    end
  end
end