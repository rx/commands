module Voom
  module Commands
    module Namespace
      include ExtractErrors
      # Will put the commands errors into a nested namespace in the error hash
      # This allows you to use a top-level command and then nest its errors into another model
      # This example the cart has shipping and billing addresses, so it does not make sense to bubble the address fields and errors up to the top level.
      def namespace_errors(lambda, namespace)
        begin
          lambda.call
        rescue Errors::ParameterValidation => e
          {namespace => extract_errors(e)}
        end
      end

      def namespace_errors!(lambda, namespace)
        response = namespace_errors(lambda, namespace)
        raise Errors::ParameterValidation.new('Form validation failed.',
                                              response) if response.respond_to?(:include?) &&
            response.include?(namespace)
        response
      end
    end
  end
end
