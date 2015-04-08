module PandaCorps
  class SeventhFloor
    def add_assistant(assistant)
      assistants << assistant
    end

    def manage(worker)
      handle_manage_start worker
      manage_worker worker
    rescue FourthFloor => support
      raise support.internal_exception unless support.suppress?
    ensure
      handle_manage_finish worker
    end

    def manage_worker(worker)
      original_manager = worker.manager
      worker.manager = self

      handle_worker_start worker
      worker.handle_start

      worker.commitments.each do |commitment|
        if commitment.type == :work
          begin
            on_work_commitment(commitment)
          rescue => e
            support = FourthFloor.new(e)
            commitment.worker.handle_exception support, commitment.worker
            handle_exception support, commitment.worker
            fire_the_whole_team(commitment.worker)
            raise support
          end
        end
        on_delegate_commitment(worker, commitment) if commitment.type == :delegate
      end
      pat_on_the_back(worker)
      fire_him(worker)
      worker.manager = original_manager
    end

    %w(worker_start worker_finish worker_accomplished manage_start manage_finish).each do |method_name|
      handle_method_name = "handle_#{method_name}"
      define_method(handle_method_name) do |worker|
        on_method_name = "on_#{method_name}"
        self.public_send(on_method_name, worker) if self.respond_to?(on_method_name)
        assistants.each { |assistant| assistant.public_send(handle_method_name, worker) }
      end
    end

    %w(debug info warning error exception bad_job).each do |method_name|
      handle_method_name = "handle_#{method_name}"
      define_method(handle_method_name) do |arg1, worker|
        on_method_name = "on_#{method_name}"
        self.public_send(on_method_name, arg1, worker) if self.respond_to?(on_method_name)
        assistants.each { |assistant| assistant.public_send(handle_method_name, arg1, worker) }
      end
    end

    private

    def pat_on_the_back(worker)
      worker.handle_accomplished
      handle_worker_accomplished worker
    end

    def fire_him(worker)
      worker.handle_finish
      handle_worker_finish worker
    end

    def fire_the_whole_team(worker)
      current_team_member = worker
      until current_team_member.nil?
        fire_him(worker)
        current_team_member = current_team_member.parent
      end
    end

    def assistants
      @assistants ||= []
    end
  end
end