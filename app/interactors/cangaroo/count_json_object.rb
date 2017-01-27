module Cangaroo
  class CountJsonObject
    include Cangaroo::Log
    include Interactor

    before :prepare_context

    def call
      context.object_count = context.data.inject({}) do |o, (k, v)|
        o[k] = v.size
        o
      end

      log.info 'total consumed payloads', count: context.object_count
    end

    private

    def prepare_context
      if context.json_body.kind_of?(String)
        context.data = JSON.parse(context.json_body)
      else
        context.data = context.json_body.dup
      end
    end
  end
end
