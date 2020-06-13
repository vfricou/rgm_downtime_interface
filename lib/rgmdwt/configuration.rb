module Rgmdwt
    class Configuration
        def self.list_apps
            config_array = Array.new
            config_files = Dir.entries(Rails.root.join("app_configs")).select {|f| !File.directory? f}
            config_files.each do |app|
                yamlContent = YAML.load_file(Rails.root.join("app_configs") + app)
                config_array << yamlContent
            end
            return config_array
        end

        def self.get_config(app_name)
            config_file = Rails.root.join("app_configs") + "#{app_name}.yml"
            #puts config_file.inspect
            yamlContent = YAML.load_file(config_file)
            #puts yamlContent.inspect
            #return yamlContent
        end
    end
end