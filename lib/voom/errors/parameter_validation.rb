require_relative 'logical_error'

module Voom
  module Errors
    class ParameterValidation < Errors::LogicalError
      attr_reader :form_errors

      def initialize(msg, form_errors = {})
        @form_errors = form_errors
        super(msg)
      end

    end
  end
end
