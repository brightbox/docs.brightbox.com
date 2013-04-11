# Creates a SimpleStreams representation of the image library

require 'time'
require 'json'

class SimpleStreams < Nanoc::Filter
  identifier :simplestreams
  type :text => :text

  def run(content, params={})
    stream_hash=Hash.new {|hash,key| hash[key] = Hash.new(&hash.default_proc)}
    item[:images].each do |image|
      stream_hash["products"][image[:name]]["username"] = image[:username] if image[:username]
      stream_hash["products"][image[:name]]["arch"] = image[:arch]
      stream_hash["products"][image[:name]]["pubname"] = image[:name]
      stream_hash["products"][image[:name]]["versions"][image[:created_at]]["items"]["brightbox_image"] = {
        "id" => image[:id]
      }
      stream_hash["products"][image[:name]]["versions"][image[:created_at]]["items"]["vagrant_box"] = {
        "path" => "vagrant/#{image[:id]}.box",
	"ftype" => "box"
      }
    end
    stream_hash["content_id"] = item[:content_id]
    stream_hash["format"] = "products:1.0"
    stream_hash["updated"] = Time.now.rfc2822
    JSON.pretty_generate(stream_hash)
  end

end

class SimpleStreamsIndex < Nanoc::Filter
  identifier :simplestreams_index
  type :text => :text

  def run(content, params={})
    stream_hash=Hash.new {|hash,key| hash[key] = Hash.new(&hash.default_proc)}
    item[:images].each do |content_id, products|
      stream_hash['index'][content_id] = {
	'cloudname' => 'brightbox',
	'format' => 'products:1.0',
        'path' => "streams/v1/#{content_id}.js",
	'products' => products.to_a
      }
    end
    stream_hash["clouds"] = [
      {
        'region' => 'gb1',
	'auth_url' => 'http://api.gb1.brightbox.com',
	'api_url' => 'http://api.gb1.brightbox.com'
      }
    ]
    stream_hash["format"] = "index:1.0"
    stream_hash["updated"] = Time.now.rfc2822
    JSON.pretty_generate(stream_hash)
  end

end

