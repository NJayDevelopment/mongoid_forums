module MongoidForums
  module ApplicationHelper
        include FormattingHelper
    # processes text with installed markup formatter
    def mongoid_forums_format(text, *options)
      as_formatted_html(text)
    end

    def mongoid_forums_quote(text)
      as_quoted_text(text)
    end

    def mongoid_forums_markdown(text, *options)
      #TODO: delete deprecated method
      Rails.logger.warn("DEPRECATION: forem_markdown is replaced by forem_format() + forem-markdown_formatter gem, and will be removed")
      forem_format(text)
    end

  end
end
