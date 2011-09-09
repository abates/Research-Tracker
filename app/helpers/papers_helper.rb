module PapersHelper
  def term_links paper
    return 'No terms associated with this paper' if paper.term_names.length == 0
    paper.term_names.map {|t| link_to t, term_path(t) }.join(', ').html_safe
  end
end
