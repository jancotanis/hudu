# frozen_string_literal: true

module Hudu
  # The AssetHelper class contains helper methods for constructing and creating asset data.
  class AssetHelper
    # Constructs an asset for updates by extracting key attributes and formatting custom fields.
    #
    # @param asset [Object] An Hudu entity that represents an asset, expected to respond to `attributes` and `fields`.
    # @return [Hash] A formatted hash representing the asset for update operations.
    #
    # @example
    #   asset = SomeAssetEntity.new(attributes: { id: 1, name: "Asset 1", company_id: 101 }, fields: [field1, field2])
    #   Hudu::AssetHelper.construct_asset(asset)
    #   # => { asset: 
    #   #      { id: 1, company_id: 101, asset_layout_id: nil, slug: nil, name: "Asset 1", custom_fields: [...]
    #   #      }
    #   #    }
    def self.construct_asset(asset)
      custom_asset = asset.attributes.slice(
        *%w[
          id company_id asset_layout_id slug name
          primary_serial primary_model primary_mail
          primary_manufacturer
        ]
      )
      custom_asset['custom_fields'] = custom_fields(asset.fields)
      { asset: custom_asset }
    end

    # Creates a new asset from the given layout and fields.
    #
    # @param name [String] The name of the new asset.
    # @param asset_layout_id [Integer] The ID of the asset layout to use.
    # @param fields [Array<Object>] A collection of field objects representing the asset's custom fields.
    # @return [Hash] A formatted hash representing the new asset.
    #
    # @example
    #   fields = [Field.new(label: "Warranty", value: "2025"), Field.new(label: "Location", value: "NYC")]
    #   Hudu::AssetHelper.create_asset("New Asset", 10, fields)
    #   # => { asset: { name: "New Asset", asset_layout_id: 10, custom_fields: [...] } }
    def self.create_asset(name, asset_layout_id, fields)
      {
        asset: {
          name: name,
          asset_layout_id: asset_layout_id,
          custom_fields: custom_fields(fields)
        }
      }
    end

    # Formats custom fields into a standardized hash structure.
    #
    # @param fields [Array<Object>] A collection of field objects, each expected to respond to `label` and `value`.
    # @return [Array<Hash>] An array containing a single hash mapping field labels 
    #                       (downcased and underscored) to their values.
    #
    # @example
    #   fields = [Field.new(label: "Warranty", value: "2025"), Field.new(label: "Location", value: "NYC")]
    #   Hudu::AssetHelper.custom_fields(fields)
    #   # => [{ "warranty" => "2025", "location" => "NYC" }]
    def self.custom_fields(fields)
      [fields.map { |field| [field.label.downcase.gsub(' ', '_'), field.value] }.to_h]
    end
  end
end
