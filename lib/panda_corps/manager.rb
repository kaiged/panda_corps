module PandaCorps
  class Manager
    def add_assistant(assistant)
      assistants << assistant
    end

    def manage(worker)
      original_manager = worker.manager
      worker.manager = self
      handle_manage_start worker

      hire_worker(worker)
      manage_worker(worker)
      fire_worker(worker)

    rescue UnhandledException => support
      raise support.internal_exception unless support.suppress?
    ensure
      worker.manager = original_manager
      handle_manage_finish worker
    end

    def hire_worker(worker)
      handle_worker_start worker
      run_commitments(worker.job_description.before_commitments, worker)
    end

    def manage_worker(worker)
      original_manager = worker.manager
      worker.manager = self
      run_commitments(worker.job_description.work_commitments, worker)
    ensure
      worker.manager = original_manager
    end

    def fire_worker(worker)
      run_commitments(worker.job_description.after_commitments, worker)
      handle_worker_finish worker
    end

    %w(worker_start worker_finish manage_start manage_finish work_commitment).each do |method_name|
      handle_method_name = "handle_#{method_name}"
      define_method(handle_method_name) do |arg1|
        on_method_name = "on_#{method_name}"
        self.public_send(on_method_name, arg1) if self.respond_to?(on_method_name)
        assistants.each { |assistant| assistant.public_send(handle_method_name, arg1) }
      end
    end

    %w(exception named_work_start named_work_finish delegate_commitment).each do |method_name|
      handle_method_name = "handle_#{method_name}"
      define_method(handle_method_name) do |arg1, arg2|
        on_method_name = "on_#{method_name}"
        self.public_send(on_method_name, arg1, arg2) if self.respond_to?(on_method_name)
        assistants.each { |assistant| assistant.public_send(handle_method_name, arg1, arg2) }
      end
    end

    %w(debug info warning error).each do |method_name|
      handle_method_name = "handle_#{method_name}"
      define_method(handle_method_name) do |arg1, arg2, arg3|
        on_method_name = "on_#{method_name}"
        self.public_send(on_method_name, arg1, arg2, arg3) if self.respond_to?(on_method_name)
        assistants.each { |assistant| assistant.public_send(handle_method_name, arg1, arg2, arg3) }
      end
    end

    private

    def run_commitments(commitments, worker)
      commitments.each do |commitment|
        next if commitment.run?
        commitment.mark_run
        run_work_commitment(commitment) if commitment.type == :work
        run_delegate_commitment(commitment, worker) if commitment.type == :delegate
      end
    end

    def run_delegate_commitment(commitment, parent)
      child_instance = commitment.work_unit.new
      child_instance.parent = parent
      hire_worker(child_instance)
      handle_delegate_commitment(parent, child_instance)
      fire_worker(child_instance)
    end

    def run_work_commitment(commitment)
      handle_work_start(commitment.name, commitment.worker) unless commitment.name.nil?
      handle_work_commitment(commitment)
      handle_work_finish(commitment.name, commitment.worker) unless commitment.name.nil?
    rescue => e
      support = UnhandledException.new(e)
      handle_exception support, commitment.worker
      fire_the_whole_team(commitment.worker)
      raise support
    end

    def fire_the_whole_team(worker)
      current_team_member = worker
      until current_team_member.nil?
        fire_worker(current_team_member)
        current_team_member = current_team_member.parent
      end
    end

    def assistants
      @assistants ||= []
    end
  end
end