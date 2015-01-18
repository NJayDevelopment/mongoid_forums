module MongoidForums
  module FormattingHelper
    # override with desired markup formatter, e.g. textile or markdown
    def as_formatted_html(text)
      if MongoidForums.formatter
        MongoidForums.formatter.format(as_sanitized_text(text))
      else
        MongoidForums::Sanitizer.sanitize(text).html_safe
      end
    end

    def as_quoted_text(text)
      if MongoidForums.formatter && Forem.formatter.respond_to?(:blockquote)
        MongoidForums.formatter.blockquote(as_sanitized_text(text)).html_safe
      else
         "<blockquote>#{(h(text))}</blockquote>\n\n".html_safe
      end
    end

    def as_sanitized_text(text)
      if MongoidForums.formatter.respond_to?(:sanitize)
        MongoidForums.formatter.sanitize(text)
      else
        Forem::Sanitizer.sanitize(text)
      end
    end
  end
end
