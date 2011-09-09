module Textiled
  module ClassMethods
    def textile *args
      options = args.extract_options!
      send :include, Textiled::InstanceMethods
      args.each do |field|
        define_method("#{field}_html") do
          markup send(field), options
        end
        define_method("#{field}_short_html") do
          truncated_markup send(field), options
        end
      end
    end
  end

  module InstanceMethods
    include ActionView::Helpers::TextHelper
    def highlight_code text, options=nil
      text = text.gsub(/^@@@ ?(\w*)\r?\n(.+?)\r?\n@@@\r?$/m) do |match|
        lang = $1.empty? ? nil : $1
        "\n<notextile>" + CodeRay.scan($2, lang).div + "</notextile>"
      end

      # get any code tags that are beyond a truncation
      text = text.gsub(/^@@@ ?(\w*)\r?\n(.+)$/m) do |match|
        lang = $1.empty? ? nil : $1
        "\n<notextile>" + CodeRay.scan($2, lang).div + "</notextile>"
      end
      text
    end
  
    def markup text, options=nil
      RedCloth.new(highlight_code(text)).to_html.html_safe
    end
  
    def truncated_markup text, options=nil
      if (text.length <= 100)
        return markup(text)
      else
        return RedCloth.new(highlight_code(truncate(text, :length => 97) + "...")).to_html.html_safe
      end
    end
  end

end

ActiveRecord::Base.send :extend, Textiled::ClassMethods
