module BackpacksFactory
  module_function

  def build(type, name, multiplier)
    Backpack.from_hash(load_backpack_params(type, name), multiplier)
  end

  def load_backpack_params(type, name)
    YAML::load_file(Rails.root.join('lib', 'backpacks', type, "#{name}.yml")).deep_symbolize_keys
  rescue Errno::ENOENT
    raise Errors::BackpackNotFound, "backpack for #{type}:#{name} does not exist"
  end
end
