require 'panda_corps/fatal_error'

module PandaCorps
  class SeventhFloor
    def add_assistant(assistant)
      assistants << assistant
    end

    def manage(worker)
      original_manager = worker.manager
      worker.manager = self

      handle_worker_start worker

      @stop_work = false
      worker.commitments.each do |commitment|
        begin
          on_work_commitment(commitment) if commitment.type == :work
          on_delegate_commitment(worker, commitment) if commitment.type == :delegate
        rescue => e
          uargs = UnhandledExceptionArgs.new(e)
          worker.handle_unhandled_exception(uargs)
          handle_fatal(e.message, worker) if uargs.fatal?
        end
      end

      handle_worker_end worker
      worker.manager = original_manager
    end

    %w(worker_start worker_end).each do |method_name|
      handle_method_name = "handle_#{method_name}"
      define_method(handle_method_name) do |worker|
        on_method_name = "on_#{method_name}"
        self.public_send(on_method_name, worker) if self.respond_to?(on_method_name)
        assistants.each { |assistant| assistant.public_send(handle_method_name, worker) }
      end
    end

    %w(debug info warning error fatal).each do |method_name|
      handle_method_name = "handle_#{method_name}"
      define_method(handle_method_name) do |message, worker|
        on_method_name = "on_#{method_name}"
        self.public_send(on_method_name, message, worker) if self.respond_to?(on_method_name)
        assistants.each { |assistant| assistant.public_send(handle_method_name, message, worker) }
        if(method_name == "fatal")
          light_a_fire message, worker
        end
      end
    end


    def light_a_fire message, worker
      raise FatalError, "#{worker}: #{message}"
    end

    private

    def assistants
      @assistants ||= []
    end
  end
end