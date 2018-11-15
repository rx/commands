require_relative 'extract_errors'

module Voom
  module Commands
    module AggregateValidations
      include Commands::ExtractErrors
      # This method will combine all parameter validation errors into a single error hash
      # Warning: If the same key exists in two validations the last one wins
      # You pass it a lambda that validates parameters.
      # EXAMPLE:
      # errors = validate_workflows(-> {@params = validate_params(params_)},
      #                             -> {@update_location_wf = update_location_wf.new(params_)})
      #
      def aggregate_validations(*lambdas)
        lambdas.reduce({}) do |errors, lambda|
          begin
            lambda.call
          rescue Errors::ParameterValidation => e
            errors.merge!(extract_errors(e))
          end
          errors
        end
      end

      def aggregate_validations!(*lambdas)
        errors = aggregate_validations(*lambdas)
        trace {errors.inspect} if errors.any?
        raise Errors::ParameterValidation.new('Form validation failed.', errors) if errors.any?
      end
    end
  end
end
