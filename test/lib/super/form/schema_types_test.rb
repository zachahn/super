require "test_helper"

class FormSchemaTypesTest < ActiveSupport::TestCase
  def test_basic
    result = Super::Form.new do |fields, type|
      fields[:name] = type.generic("cool_partial_path")
    end

    assert_equal(
      {
        name: Super::Form::SchemaTypes::Generic.new(
          partial_path: "cool_partial_path",
          extras: {},
          nested: {}
        ),
      },
      result.instance_variable_get(:@fields).to_h
    )
  end

  def test_has_many
    result = Super::Form.new do |fields, type|
      fields[:widgets_attributes] = type.has_many(:widgets) do
        fields[:name] = type.generic("cool_partial_path")
      end
    end

    assert_equal(
      {
        widgets_attributes: Super::Form::SchemaTypes::Generic.new(
          partial_path: "form_has_many",
          extras: { reader: :widgets },
          nested: {
            name: Super::Form::SchemaTypes::Generic.new(
              partial_path: "cool_partial_path",
              extras: {},
              nested: {}
            )
          }
        )
      },
      result.instance_variable_get(:@fields).to_h
    )
  end
end
