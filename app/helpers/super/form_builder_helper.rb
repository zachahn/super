module Super
  module FormBuilderHelper
    def super_form_for(record, options = {}, &block)
      original = ActionView::Base.field_error_proc
      ActionView::Base.field_error_proc = Form::Builder::FIELD_ERROR_PROC

      options[:builder] ||= Form::Builder
      return form_for(record, options, &block)
    ensure
      ActionView::Base.field_error_proc = original
    end
  end
end
