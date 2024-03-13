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
  private
    def self.custom_fields(fields)
      [fields.map{|field| [field.label.downcase.gsub(' ','_'),field.value]}.to_h]
    end

  end
end