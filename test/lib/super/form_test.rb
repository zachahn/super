require "test_helper"

class FormTest < ActionView::TestCase
  include Super::FormBuilderHelper

  def test_super_form_for_doesnt_have_default_error_proc
    member = members(:picard)
    member.name = nil
    member.valid?

    concat_form_for([:admin, members(:picard)], html: { class: "first" }) do |f|
      f.text_field :name
    end
    assert_select "form.first" do
      assert_select ".field_with_errors"
    end

    concat_super_form_for([:admin, members(:picard)], html: { class: "second" }) do |f|
      f.text_field :name
    end
    assert_select "form.second" do
      assert_select ".field_with_errors", 0
    end
  end

  private

  def concat_form_for(record, options = {}, &block)
    concat(form_for(record, options, &block))
  end

  def concat_super_form_for(record, options = {}, &block)
    concat(super_form_for(record, options, &block))
  end
end
