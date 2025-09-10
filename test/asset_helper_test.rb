# frozen_string_literal: true

require 'test_helper'

Field = Struct.new(:label, :value)
Asset = Struct.new(:attributes, :fields)

describe 'AssetHelper' do
  it '#1 construct_asset' do
    ## write test for AssetHelper.construct_asset
    field1 = Field.new('This is a custom Field', 'value1')
    field2 = Field.new('Another Field', 'value2')
    asset = Asset.new({ 'id' => 1, 'name' => 'Asset 1', 'company_id' => 101 }, [field1, field2])
    result = Hudu::AssetHelper.construct_asset(asset)
    assert(result['name'], 'Asset 1')
    assert(result['custom_fields'].first['this_is_a_custom_field'], 'value1')
  end
  it '#2 create_asset' do
    asset = Hudu::AssetHelper.create_asset('Asset name', 10, [Field.new('Field1', 'value1')])
    assert(asset[:asset][:name], 'Asset name')
    assert(asset[:asset][:asset_layout_id], 10)
  end
  it '#3 custom_fields' do
    spaces = Field.new('This is a custom Field', 'value')
    field = Hudu::AssetHelper.custom_fields([spaces]).first
    # returns a hash with downcased and underscored keys
    assert(field.count, 1)
    assert(field['this_is_a_custom_field'], spaces.value)
  end
end
