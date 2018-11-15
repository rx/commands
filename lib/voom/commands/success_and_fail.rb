require_relative 'codes'
require_relative 'response'

module Voom
  module Commands
    module SuccessAndFail
      def success(data: [], warnings: {}, snackbar: [])
        SuccessAndFail.success(data: data, warnings: warnings, snackbar: snackbar)
      end

      def fail(status: Commands::Codes::FAILURE, errors: {}, warnings: {}, data: [])
        SuccessAndFail.fail(status: status, errors: errors, warnings: warnings, data: data)
      end

      def self.success(data: [], warnings: {}, snackbar: [])
        Response.new(data: data, status: Commands::Codes::SUCCESS, messages: {errors: {}, warnings: warnings, snackbar: snackbar})
      end

      def self.fail(status: Commands::Codes::FAILURE, errors: {}, warnings: {}, data: [])
        Response.new(data: data, status: status, messages: {errors: errors, warnings: warnings})
      end

    end
  end
end
