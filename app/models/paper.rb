require 'bibtex'

class Paper < ActiveRecord::Base
  has_and_belongs_to_many :projects
  has_and_belongs_to_many :terms
  has_many :notes, :as => :notable
  after_save :set_terms, :update_bibtex_key
  after_destroy :delete_file
  after_initialize :parse_bibtex

  attr_reader :bib_items, :paper_type

  @@dir = "#{::Rails.root}/data/attachments"

  def file= data
    write_attribute(:original_filename, data.original_filename)
    write_attribute(:content_type, data.content_type)
    filename = Digest::SHA1.hexdigest("#{Time.now.to_s}#{original_filename}")
    write_attribute(:filename, "attachment_#{filename}")

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

  private
    def parse_bibtex
      @bib_items = {}
      unless bibtex.nil? || bibtex.empty?
	@parsed_bibtex = BibTeX.parse(bibtex)[0]

	if (@parsed_bibtex.instance_of? BibTeX::Error)
	  @bib_items[:bibtex_parse_error] = @parsed_bibtex.content
	  @bib_items[:bibtex_error_trace] = @parsed_bibtex.trace
	  @parsed_bibtex = nil
	else
	  @parsed_bibtex.entries.each do |k, v|
	    @bib_items[k] = v
	  end
	end
      end
    end

    def delete_file
      begin
        unless filename.nil? || filename.empty?
          File.delete(file)
        end
      rescue => e
        logger.warn("Failed to delete file: #{e}")
      end
    end

    def update_bibtex_key
      begin
        unless(@parsed_bibtex.nil?)
          author = @parsed_bibtex[:author].split(/,/)[0]
          key = "#{author}_#{id}"
	  unless(@parsed_bibtex.nil? || @parsed_bibtex.key == key)
	    @parsed_bibtex.key = key;
	    update_attribute(:bibtex, @parsed_bibtex.to_s)
          end
        end
      rescue => e
	logger.error("Failed to set citation key for bibtex: #{e}")
	logger.error("\t#{e.backtrace.join("\n\t")}")
      end
    end

    def set_terms
      terms.clear
      @term_names.split(/\s*,\s*/).each do |name|
	term = Term.first(:conditions => ['name=?', name])
	if (term.nil?)
	  term = Term.create(:name => name)
	end
	terms << term
      end unless (@term_names.nil?)
    end

end
