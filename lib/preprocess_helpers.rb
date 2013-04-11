require 'set'

module PreprocessHelpers

  def generate_vagrant!
    images = fetch_available_images.
      sort do |a, b|
	[a[:owner], a[:name], a[:arch]] <=> [b[:owner], b[:name], b[:arch]]
      end
    @items << Nanoc3::Item.new("", { :title => "Vagrant server images", :images => images }, "/vagrant/images" )
  end

  def generate_simplestreams!
#    stream_hash=Hash.new {|hash,key| hash[key] = Hash.new(&hash.default_proc)}
    official_images, public_images =
      fetch_available_images.partition { |i| i[:official] }
    @items << Nanoc3::Item.new("", { :content_id => "com.brightbox:official", :images => official_images }, "/streams/v1/com.brightbox:official")
    @items << Nanoc3::Item.new("", { :content_id => "com.brightbox:public", :images => public_images }, "/streams/v1/com.brightbox:public")
    @items << Nanoc3::Item.new("", { :title => "image index", :images => {
      "com.brightbox:official" => get_products(official_images),
      "com.brightbox:public" => get_products(public_images)
      } }, "/streams/v1/index")
  end
      
  def get_products(image_list)
    image_list.inject(Set.new) { |set, i| set << i[:name] }
  end

  def fetch_available_images
    @items.select do |item|
      item[:kind] == "brightbox_image" && item[:status] == "available"
    end
  end

end
