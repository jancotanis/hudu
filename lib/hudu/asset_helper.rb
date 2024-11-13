module Hudu

  class AssetHelper
    # Construct asset for updates, assuem it is an entity
    def self.construct_asset asset
      custom_asset = asset.attributes.slice( *%w(
        id company_id asset_layout_id slug name 
        primary_serial primary_model primary_mail 
        primary_manufacturer ) 
      )
      custom_asset['custom_fields'] = self.custom_fields(asset.fields)
      { asset: custom_asset }
    end

    # create new asset from layout
    def self.create_asset name, asset_layout_id, fields
      custom_asset = { 
        asset: {
          name: name,
          asset_layout_id: asset_layout_id,
          custom_fields: self.custom_fields(fields)
        }
      }
    end
  
  private
    def self.custom_fields(fields)
      [fields.map{|field| [field.label.downcase.gsub(' ','_'),field.value]}.to_h]
    end

  end
end