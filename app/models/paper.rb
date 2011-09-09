require 'bibtex'

class Paper < ActiveRecord::Base
  has_and_belongs_to_many :terms
  has_many :notes, :as => :notable

  attr_reader :bib_items, :paper_type

  @@dir = 'data/attachments'

  def after_destroy
    unless filename.nil? || filename.empty?
      File.delete(file)
    end
  end

  def after_initialize
    @bib_items = {}
    unless bibtex.nil? || bibtex.empty?
      tex = BibTeX.parse(bibtex)[0]

      if (tex.instance_of? BibTeX::Error)
        @bib_items[:bibtex_parse_error] = tex.content
        @bib_items[:bibtex_error_trace] = tex.trace
      else
        tex.entries.each do |k, v|
          @bib_items[k] = v
        end
      end
    end
  end

  def after_save
    terms.clear
    @term_names.split(/\s*,\s*/).each do |name|
      term = Term.first(:conditions => ['name=?', name])
      if (term.nil?)
        term = Term.create(:name => name)
      end
      terms << term
    end
  end

  def file= data
    write_attribute(:original_filename, data.original_filename)
    write_attribute(:content_type, data.content_type)
    filename = Digest::SHA1.hexdigest("#{Time.now.to_s}#{original_filename}")
    write_attribute(:filename, filename)

    File.open(file, "wb") { |f| f.write(data.read) }
  end

  def file
    if (filename.empty?)
     return ""
    end
    File.join(@@dir, filename)
  end

  def term_names= term_names
    @term_names = term_names
  end
    
  def term_names
    terms.map { |t| t.name }
  end

  def to_s
    original_filename
  end
end
