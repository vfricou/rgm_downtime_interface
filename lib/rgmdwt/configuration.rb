module Rgmdwt
  class Configuration
    def self.list_apps
      config_array = []
      config_files = Dir.entries(Rails.root.join(Rails.configuration.rgmdwt[:app_config])).reject { |f| File.directory? f }
      config_files.each do |app|
        config_array << YAML.load_file(Rails.root.join(Rails.configuration.rgmdwt[:app_config]) + app).merge({file_name: app})
      end

      config_array
    end

    def self.get_config(app_name)
      config_file = Rails.root.join(Rails.configuration.rgmdwt[:app_config]) + "#{app_name}.yml"
      #puts config_file.inspect
      yamlContent = YAML.load_file(config_file)
      #puts yamlContent.inspect
      #return yamlContent
    end
  end
end
