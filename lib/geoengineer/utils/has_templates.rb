########################################################################
# HasTemplates provides methods for a class to contain and query a set of templates
########################################################################
module HasTemplates
  def templates
    @_templates ||= {}
  end

  # Templating Methods
  def find_template(type)
    clazz_name = type.split('_').collect(&:capitalize).join
    return Object.const_get(clazz_name) if Object.const_defined? clazz_name

    module_clazz = "GeoEngineer::Templates::#{clazz_name}"
    return Object.const_get(module_clazz) if Object.const_defined? module_clazz

    throw "undefined template '#{type}' for '#{clazz_name}' or 'GeoEngineer::#{clazz_name}'"
  end

  def from_template(type, name, parameters = {}, &block)
    throw "Template '#{name}' already defined" if templates[name]
    clazz = find_template(type)
    template = clazz.new(name, self, parameters)
    template.instance_exec(*template.template_resources, &block) if block_given?
    templates[name] = template
  end

  def all_template_resources
    templates.values.map(&:all_resources).flatten
  end
end
