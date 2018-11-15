require 'voom/errors/parameter_validation'

module Voom
  module Commands
    module ValidateParams
      def schema
        raise 'You must implement schema!'
      end

      def validate_params(**params_)
        result = schema.call(params_.symbolize_keys)
        # trace { result.inspect }
        raise Errors::ParameterValidation.new("Form validation failed: #{humanize(result.messages(full: true))}",
                                              humanize(result.messages(full: true))) if result.failure?
        result.to_h
      end

      private

      def humanize(messages)
        messages.map do |key, messages|
          [
              key,
              messages.map do |msg|
                msg.humanize
              end
          ]
        end.to_h
      end
    end
  end
end
