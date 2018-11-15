require_relative 'messages'

module Voom
  module Commands
    class Response
      attr_reader :data, :status, :messages
      SUCCESS = 0
      FAILURE = 1

      def initialize(data: [],
                     status: SUCCESS,
                     messages: {})
        @data = data
        @status = status
        @messages = Messages.new(messages)
      end

      # If your data either is a hash or is an array containing one hash
      # This helper allows you to treat the result object as a hash
      # returns nil if there is more than one element in the data
      # Or if the data is empty
      def [](key)
        return data[key] if data.respond_to?(:key?) #quacks like a hash
        return data.send(key.to_sym) if data.respond_to?(key.to_sym) #behaves like a model/entity
        return nil if data.empty? or data.size > 1
        data.first[key] if data.first.respond_to?(:key?)
      end

      def <<(output)
        @data << output
      end

      def succeeded?
        @status == SUCCESS
      end

      alias success? succeeded?

      def failed?
        !succeeded?
      end

      alias fail? failed?

      def to_h
        {data: data,
         status: status,
         message: messages.to_h}
      end

      def errors
        @messages.errors
      end

      def warnings
        @messages.warnings
      end
    end
  end
end
