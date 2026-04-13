macro singleton_methods(*method_names)
  {% for name in method_names %}
    def self.{{name}}(*args, **kwargs)
      instance.{{name}}(*args, **kwargs)
    end

    def self.{{name}}(*args, **kwargs, &block)
      instance.{{name}}(*args, **kwargs, &block)
    end
  {% end %}
end
