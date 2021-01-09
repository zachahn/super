module Super
  class Form
    # Example
    #
    # ```ruby
    # super_form_for([:admin, @member]) do |f|
    #   f.super.label :name
    #   f.super.text_field :name
    #   f.super.select :rank
    #   f.super.text_field! :position
    #
    #   f.super.label :name
    #   f.super.text_field :name
    # end
    # ```
    class Builder < ActionView::Helpers::FormBuilder
      FIELD_ERROR_PROC = proc { |html_tag, instance| html_tag }
      FORM_BUILDER_DEFAULTS = { builder: self }.freeze

      def super
        @super_wrappers ||= Wrappers.new(self)
      end

      class Wrappers
        def initialize(builder)
          @builder = builder
          @template = builder.instance_variable_get(:@template)
        end

        def inline_errors(attribute)
          if @builder.object
            messages = InlineErrors.error_messages(@builder.object, attribute).map do |msg|
              error_content_tag(msg)
            end

            @template.safe_join(messages)
          else
            error_content_tag(<<~MSG.html_safe)
              This form doesn't have an object, so something is probably wrong.
              Maybe <code>accepts_nested_attributes_for</code> isn't set up?
            MSG
          end
        end

        def label(attribute, options = {}, &block)
          options = options.dup
          options[:class] = ["block", options[:class]].compact.join(" ")

          @builder.label(attribute, options)
        end

        def text_field(attribute, options = {})
          options = options.dup
          options[:class] = ["super-input w-full", options[:class]].compact.join(" ")

          @builder.text_field(attribute, options)
        end

        private

        def split_options(options)
          options = options.dup
          super_options = options.delete(:super) || {}
        end

        def error_content_tag(content = nil)
          content = content || yield
          @template.content_tag(:p, content, class: "text-red-400 text-xs italic pt-1")
        end
      end
    end
  end
end
