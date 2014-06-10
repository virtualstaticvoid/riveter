require 'action_view'

module Riveter
  module FormBuilderExtensions

    def search
      submit I18n.translate(:search, :scope => [:forms]), :name => :search
    end

    def reset
      submit I18n.translate(:reset, :scope => [:forms]), :name => :reset
    end

  end
end

module ActionView::Helpers
  class FormBuilder
    include Riveter::FormBuilderExtensions
  end
end
