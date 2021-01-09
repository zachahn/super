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

  def test_inline_errors
    member = members(:picard)
    member.name = nil
    member.valid?

    concat_super_form_for([:admin, member]) do |f|
      f.super.inline_errors :name
    end

    assert_dom_equal(<<~HTML.strip, css_select("form > p").first.to_s)
      <p class="text-red-400 text-xs italic pt-1">Name can't be blank</p>
    HTML
  end

  def test_label
    concat_super_form_for([:admin, members(:picard)]) do |f|
      f.super.label :name
    end

    assert_dom_equal(<<~HTML.strip, css_select("label").first.to_s)
      <label class="block" for="member_name">Name</label>
    HTML
  end

  def test_text_field
    concat_super_form_for([:admin, members(:picard)]) do |f|
      f.super.text_field :name
    end

    assert_dom_equal(<<~HTML.strip, css_select("input[type=text]").first.to_s)
      <input
        class="super-input w-full"
        type="text"
        name="member[name]"
        id="member_name"
        value="#{members(:picard).name}"
        />
    HTML
  end

  private

  def concat_form_for(record, options = {}, &block)
    concat(form_for(record, options, &block))
  end

  def concat_super_form_for(record, options = {}, &block)
    concat(super_form_for(record, options, &block))
  end
end
