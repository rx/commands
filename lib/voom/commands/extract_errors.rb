module Voom
  module Commands
    module ExtractErrors
      def extract_fk_errors(e)
        errmsg = e.message
        table, _foreign_key, foreign_table = e.message.match(/PG::ForeignKeyViolation: ERROR:.*\"(.*)\".*\"(.*)\"[\n].*\"(.*)\"/)&.captures
        if table && _foreign_key && foreign_table
          errmsg = "Unable to delete or update #{table.singularize.humanize.titleize}. "\
                                "It is referred to from one or more #{foreign_table.humanize.titleize}. "\
                                "You will need to update or remove any #{foreign_table.humanize.titleize} that refer to this "\
                                "#{table.singularize.humanize.titleize} first."
        end
        {exception: errmsg}
      end

      def extract_errors(e)
        return e.form_errors if e.respond_to?(:form_errors) && e.form_errors.any?
        {exception: e.message}
      end
    end
  end
end
