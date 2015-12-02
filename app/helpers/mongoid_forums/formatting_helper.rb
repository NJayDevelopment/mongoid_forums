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
      if MongoidForums.formatter && MongoidForums.formatter.respond_to?(:blockquote)
        MongoidForums.formatter.blockquote(as_sanitized_text(text)).html_safe
      else
         "<blockquote>#{(h(text))}</blockquote>\n\n".html_safe
      end
    end

    def as_sanitized_text(text)
      if MongoidForums.formatter.respond_to?(:sanitize)
        MongoidForums.formatter.sanitize(text)
      else
        MongoidForums::Sanitizer.sanitize(text)
      end
    end

    def emojify(content)
      h(content).to_str.gsub(/:([\w+-]+):/) do |match|
        if emoji = Emoji.find_by_alias($1)
          %(<img alt="#$1" src="#{asset_path("emoji/#{emoji.image_filename}", type: :image)}" style="vertical-align:middle" width="20" height="20" />)
        else
          match
        end
      end.html_safe if content.present?
    end

  end
end
