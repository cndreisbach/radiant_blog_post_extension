unless String.instance_methods.include? 'slugize'
  class String
    def slugize
      slug = Iconv.iconv('ascii//TRANSLIT//IGNORE', 'utf-8', self).to_s
      slug = slug.gsub(/&/, 'and')
      slug = slug.gsub(/[^\w_-]+/, '-')
      slug = slug.gsub(/\-{2}/, '-')
      URI.escape(slug.downcase, /[^\w_-]/)
    end
  end
end

unless Object.instance_methods.include? 'try'
  class Object
    def try(method, *args, &block)
      send(method, *args, &block)
    end
  end
  
  class NilClass
    def try(*args)
      nil
    end
  end
end