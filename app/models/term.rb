require 'net/http'

class Term < ActiveRecord::Base
  has_and_belongs_to_many :papers
  has_many :definitions
  validates_uniqueness_of :name

  def after_create
    update_definitions_from_wiktionary
  end

  def update_definitions_from_wiktionary
    resp = ""
    http = Net::HTTP.new("en.wiktionary.org", 80)
    http.start do |http|
      req = Net::HTTP::Get.new("/w/api.php?action=query&prop=revisions&rvprop=content&titles=#{name}&format=xml", {
        "User-Agent" => "Dictionary term lookups for thesis work -- abates@uccs.edu"
      })
      response = http.request(req)
      resp = response.body
    end

    terms = {}
    part = ''
    resp.split(/\n/).each do |line|
      if (line.match(/^====([^=]+)====/))
        part = $1
      elsif (line.match(/^\#.*$/))
        next if (line =~ /^\#\*/)
        line.gsub!(/^\#/, '')
        line.gsub!(/\[\[|\]\]/, '')
        line.gsub!(/\{\{/, '(')
        line.gsub!(/\}\}/, ')')
        line.gsub!(/\&lt;/, '<')
        line.gsub!(/\&gt;/, '>')

        line.gsub!(/\<\!--.*--\>/, '')
        definitions.create(:part => part, :text => ERB::Util::html_escape(line.strip))
      end
    end
  end
end
