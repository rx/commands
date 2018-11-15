require_relative 'success_and_fail'
require_relative 'extract_errors'
require 'voom/errors/logical_error'

module Voom
  module Commands
    module RescueLogicalErrors
      include Commands::SuccessAndFail
      include Commands::ExtractErrors

      # A logical error is one that we can notify the user about and they can use that information to fix their request
      # ParameterValidation is a logical error
      # UnableToFind or AR::RecordNotFound is a logical error
      # Foreign key violations - might be logical so we handle them as such
      # Anything else is logged, honey badger is notified and a 500 is returned.
      def rescue_logical_errors(&block)
        begin
          block.call
        rescue Errors::LogicalError => e
          fail(errors: extract_errors(e), status: 422)
        rescue ActiveRecord::RecordNotFound => e
          fail(errors: extract_errors(e), status: 404)
        rescue ActiveRecord::InvalidForeignKey => e
          fail(errors: extract_fk_errors(e), status: 422)
        rescue StandardError => e
          Rails.logger.error {e.message}
          Rails.logger.error {e.backtrace.join("\n")}
          Honeybadger.notify(e) if defined?(Honeybadger)
          fail(errors: e.message, status: 500)
        end
      end
    end
  end
end
