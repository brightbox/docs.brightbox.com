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
      unless raw_item["status"] == "deleted" && raw_item["public"]
	mtime = Time.parse(raw_item["created_at"])
	attributes = raw_item.dup
	attributes.delete("ancestor")
	identifier = "/#{raw_item['id']}/"

	result << Nanoc::Item.new(JSON.dump(attributes), attributes, identifier, mtime)
      end
    end
  rescue Excon::Errors::Unauthorized
    raise "Failed to connect to Brightbox API. Check Fog credentials"
  end

end



