module PandaCorps
  class RequirementError < StandardError
    def self.no_key(requirement, from, to)
      build_error_with_message("not provided by #{from.title}", from, requirement, to)
    end

    def self.bad_requirement(requirement, from, to, item)
      build_error_with_message(item.class.name, from, requirement, to)
    end

    private
    def self.build_error_with_message(error, from, requirement, to)
      sum = summary(requirement, to)
      desc = description(requirement, from, to)
      expect = expectation(requirement)
      err = "Received '#{requirement.name}' as: #{error}"
      RequirementError.new("#{sum}\n\n #{desc}\n   #{expect}\n   #{err}\n\n")
    end

    def self.description(requirement, from, to)
      "While giving '#{requirement.name}' to #{to.title} from #{from.title}:"
    end

    def self.expectation(requirement)
      as = requirement.validation.nil? ? "anything" : requirement.validation
      "Expected '#{requirement.name}' as: #{as}"
    end

    def self.summary(requirement, to)
      "Error applying '#{requirement.name}' to #{to.title}."
    end
  end
end