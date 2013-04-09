# Creates Brightbox Vagrant box files from image attributes

require 'tmpdir'

class VagrantBoxes < Nanoc::Filter
  identifier :box
  type :text => :binary

  def run(content, params={})
    Dir.mktmpdir do |dir|
      File.open(File.join(dir,"metadata.json"), "w") do |f|
        f.syswrite('{ "provider": "brightbox" }')
      end
      image_entry = "brightbox.image_id = '#{item[:id]}'" if item[:id]
      username_entry = "brightbox.ssh_username = '#{item[:username]}'" if item[:username]
      File.open(File.join(dir,"Vagrantfile"), "w") do |f|
        f.syswrite <<-END
Vagrant.configure("2") do |config|
  config.vm.provider :brightbox do |brightbox|
    #{image_entry}
    #{username_entry}
  end
end
	END
      end
      system(
             'tar',
             '--owner=nobody',
             '--group=nogroup',
             '-cvzf', output_filename,
             '--directory', dir,
             './metadata.json',
             './Vagrantfile'
      ) || raise("Failed to create box file")
    end
  end

end
