module Super
  class Form
    class Builder < ActionView::Helpers::FormBuilder
      FIELD_ERROR_PROC = proc { |html_tag, instance| html_tag }
      FORM_BUILDER_DEFAULTS = { builder: self }.freeze
    end
  end
end
