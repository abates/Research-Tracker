module ApplicationHelper
  def self.included(base)
    ['add', 'edit', 'destroy', 'download', 'view', 'reference', 'annotate', 'show'].each do |action|
      define_method("link_to_large_#{action}") do |*args|
        link_to_action action, 'large', *args
      end
      define_method("link_to_small_#{action}") do |*args|
        link_to_action action, 'small', *args
      end
    end
  end

  def trunc s
    if (s.length <= 100) 
      return s
    else
      return truncate s, 100
    end
  end

  def link_to_action action, size, *args
    name = args.shift
    link_to image_tag("#{action}_#{size}.png", :alt => name, :title => name), *args
  end
end
