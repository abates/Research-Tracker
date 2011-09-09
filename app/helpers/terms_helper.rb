module TermsHelper
  def definition name, definitions
    output = "<dl><dt>#{name}</dt>"
    definitions.each do |definition|
      output += '<dd>'
      output += definition.to_s
      output += '</dd>'
    end
    output += '</dl>'
    output.html_safe
  end

  def definitions term
    output = ""
    if (term.definitions.length == 0)
      output = "<p>No local definitions found for #{term.name}</p>"
    else
      output += definition term.name, term.definitions
    end
    output.html_safe
  end

  def wiktions term
    output = ""
    if (term.wiktions.length == 0)
      output = "<p>No wiktionary definitions found for #{term.name}</p>"
    end
    term.wiktions.each do |part, definitions|
      next if (definitions.length == 0)
      unless (part =~ /default/)
        output += "<h3>#{part}</h3>"
      end
      output += definition term.name, definitions
    end
    output.html_safe
  end
end
