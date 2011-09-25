require 'zip/zip'
require 'zip/zipfilesystem'

class Project < ActiveRecord::Base
  textile :description

  has_many :notes, :as => :notable
  has_and_belongs_to_many :papers
  has_many :tasks
  has_many :documents

  def to_s
    name
  end

  def backup
    filename = Digest::SHA1.hexdigest("#{Time.now.to_s}#{name}")
    filename = "#{::Rails.root}/data/backups/backup_#{filename}"

    Zip::ZipOutputStream.open(filename) do |zos|
      zos.put_next_entry("manifest.xml")
      zos.print to_xml(:include => [:notes, :papers, :tasks])
      papers.each do |paper|
        zos.put_next_entry(paper.filename)
        zos.print IO.read(paper.file)
      end
    end
    filename
  end
end
