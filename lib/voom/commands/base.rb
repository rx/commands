require_relative 'success_and_fail'
require_relative 'validate_params'
require_relative 'rescue_logical_errors'
require_relative 'aggregate_validations'
require_relative 'namespace'

module Voom
  module Commands
    class Base
      include Commands::SuccessAndFail
      include Commands::ValidateParams
      include Commands::AggregateValidations
      include Commands::Namespace
      class << self
        include Commands::RescueLogicalErrors
      end

      attr_reader :params

      def initialize(*args, **params_, &block)
        @params = params_.any? ? validate_params(**params_) : {}
        @block = block
      end

      def call
        response = self.perform
        response = response.respond_to?(:success?) ? response : success
        response2 = @block.call(response, self) if @block
        response = response2.respond_to?(:success?) ? response2 : response
        response.respond_to?(:success?) ? response : success
      end

      def self.call(*args, **params, &block)
        rescue_logical_errors {new(*args, **params, &block).call(&block)}
      end

      def self.call!(*args, **params, &block)
        self.new(*args, **params, &block).call(&block)
      end
    end
  end
end
