require 'set'

module PreprocessHelpers

  def generate_vagrant!
    images = fetch_available_images.
      sort do |a, b|
	[a[:owner], a[:name], a[:arch]] <=> [b[:owner], b[:name], b[:arch]]
      end
    @items << Nanoc::Item.new("", { :title => "Vagrant server images", :images => images }, "/vagrant/images/" )
    #Add dummy image
    @items << Nanoc::Item.new('', {}, "/vagrant/dummy/")
  end

  def generate_simplestreams!
#    stream_hash=Hash.new {|hash,key| hash[key] = Hash.new(&hash.default_proc)}
    official_images, public_images =
      @items.select { |i| i[:kind] == "brightbox_image" && fetch_upstream_details(i) }.partition { |i| i[:official] }
    daily_public_images, released_public_images = public_images.partition { |i| fetch_upstream_details(i).last == 'daily' }
    index_images = {}
    unless official_images.empty?
      @items << Nanoc::Item.new("", { :content_id => "com.brightbox:official", :images => official_images }, "/streams/v1/com.brightbox:official")
      index_images["com.brightbox:official"] = get_products(official_images)
    end
    unless released_public_images.empty?
      @items << Nanoc::Item.new("", { :content_id => "com.brightbox:public:released", :images => released_public_images }, "/streams/v1/com.brightbox:public:released")
      index_images["com.brightbox:public:released"] = get_products(released_public_images)
    end
    unless daily_public_images.empty?
      @items << Nanoc::Item.new("", { :content_id => "com.brightbox:public:daily", :images => daily_public_images }, "/streams/v1/com.brightbox:public:daily") unless daily_public_images.empty?
      index_images["com.brightbox:public:daily"] = get_products(daily_public_images)
    end
    @items << Nanoc::Item.new("", { :title => "image index", :images => index_images
      }, "/streams/v1/index") unless index_images.empty?
  end
      
  def get_products(image_list)
    image_list.inject(Set.new) do |set, i|
      content, product, version, item, release = fetch_upstream_details(i)
      set << product if product
    end
  end

  def fetch_upstream_details(image_details)
    image_details[:description] =~  %r{^ID: ([\w\.:]+)/([\w\.:]+)/(\S+)/(\S+), Release: (\S+)} && Regexp.last_match.captures
  end

  def fetch_available_images
    @items.select do |item|
      item[:kind] == "brightbox_image" && item[:status] == "available"
    end
  end


end
