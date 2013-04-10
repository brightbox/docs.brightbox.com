require 'fog'

class BrightboxImages < Nanoc::DataSource

  identifier :brightbox_images

  def items
    @items ||= fetch_images
  end

  # Put the credentials in the ~/.fog file
  def up
    @connection = Fog::Compute.new(:provider => :brightbox)
  end

private

  require 'json'

  def fetch_images
    raw_items = @connection.list_images

    raw_items.inject([]) do |result, raw_item|
      if raw_item["public"] && raw_item["status"] != "deleted"
        mtime = Time.parse(raw_item["created_at"])
        attributes = raw_item.dup
        attributes.delete("ancestor")
        rendered = JSON.dump(attributes)

        attributes[:title] = attributes["id"]
        attributes[:kind] = "brightbox_image"
        identifier = "/#{raw_item['id']}/"

        result << Nanoc::Item.new(rendered, attributes, identifier, mtime)
      end
      result
    end
  rescue Excon::Errors::Unauthorized
    raise "Failed to connect to Brightbox API. Check Fog credentials"
  end

end



