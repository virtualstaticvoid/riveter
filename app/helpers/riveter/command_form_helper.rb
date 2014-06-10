module Riveter
  module CommandFormHelper
    def command_form_for(command, options={}, &block)
      command_class_name = command.class.name.underscore
      options = {
        :as => command_class_name.gsub(/_command$/, ''),
        :url => command_class_name.gsub(/_command$/, '')
      }.merge(options)

      respond_to?(:simple_form_for) ?
        simple_form_for(command, options, &block) :
        form_for(command, options, &block)
    end
  end
end
