module Voom
  module Commands
    module ControllerResponse
      def handle_response(response, &block)
        if response.success?
          redirect_url = redirect_url(response, &block)
          if redirect_url
            redirect_to redirect_url, status: :see_other
          else
            render json: response.data, status: 200
          end
        else
          render json: response.messages, status: response.status
        end
      end

      # If you pass a block then return a hash for any parameters you want to add to the redirect
      # If you want to forward some parameters from the response, pass the parameter names in pluck
      def redirect_url(response = nil, pluck: [], &block)
        redirect_url = params.fetch(:redirect) {nil}
        return unless redirect_url

        data = response ? response.data : {}
        data = block.call(data) if block

        data = data.to_hash if data.respond_to?(:to_hash)
        data = data.attributes if data.respond_to?(:attributes)
        data = data.deep_symbolize_keys if data.respond_to?(:deep_symbolize_keys)
        trace {"Data: #{data.inspect}"}

        pluck = Array(params.fetch(:pluck) {pluck}).map(&:to_sym)
        trace {"Plucking: #{pluck.inspect}"}
        data = pluck.map do |key|
          [key, data.fetch(key) {params[key]}]
        end.to_h

        data[:snackbar] = response.messages.snackbar if response&.messages&.snackbar

        query = data.to_query
        trace {"Query: #{query.inspect}"}

        redirect_url = "#{redirect_url}#{url_seperator(redirect_url)}#{query}" unless query.empty?
        redirect_url
      end

      private

      def url_seperator(redirect_url)
        redirect_url.include?('?') ? '&' : '?'
      end
    end
  end
end
