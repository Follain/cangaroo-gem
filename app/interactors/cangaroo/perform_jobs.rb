module Cangaroo
  class PerformJobs
    include Interactor

    def call
      data.each do |type, payloads|
        payloads.each { |payload| enqueue_jobs(type, payload) }
      end
    end

    private

    def data
      @data ||= json_body
    end

    def json_body
      if context.json_body.kind_of?(String)
        JSON.parse(context.json_body)
      else
        context.json_body
      end
    end

    def enqueue_jobs(type, payload)
      initialize_jobs(type, payload).select(&:perform?).each(&:enqueue)
    end

    def initialize_jobs(type, payload)
      context.jobs.map do |klass|
        klass.new(
          connection: context.source_connection,
          type: type,
          payload: payload
        )
      end
    end
  end
end
