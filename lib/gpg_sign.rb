class GpgSign < Nanoc::Filter
  identifier :gpgsign
  type :text => :text

  def run(content, params={})
    sign = params[:clearsign] ? "--clearsign" : "--sign"
    key = params[:key] || @config[:default_key]
    key = "--default-key #{key}" if key
    cmd = "|gpg --batch --armor #{key} #{sign}"
    signed = open(cmd, 'w+') do |sp|
      sp.write(content)
      sp.close_write
      sp.read
    end
    raise "GPG error" unless $?.success?
    signed
  end

end
