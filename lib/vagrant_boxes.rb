# Creates Brightbox Vagrant box files from image attributes

require 'tmpdir'

class VagrantBoxes < Nanoc::Filter
  identifier :box
  type :text => :binary

  def vagrantfile_configure(io)
    io.syswrite <<-END
Vagrant.configure("2") do |config|
  config.vm.provider :brightbox do |brightbox, override|
    END
    yield
    io.syswrite <<-END
  end
end
    END
  end

  def image_entry(io)
    io.syswrite <<-END
    brightbox.image_id = '#{item[:id]}'
    END
  end

  def username_entry(io)
    io.syswrite <<-END
    override.ssh.username = '#{item[:username]}' if override
    END
  end
      
  def run(content, params={})
    Dir.mktmpdir do |dir|
      File.open(File.join(dir,"metadata.json"), "w") do |f|
        f.syswrite('{ "provider": "brightbox" }')
      end
      File.open(File.join(dir,"Vagrantfile"), "w") do |f|
	vagrantfile_configure(f) do
	  image_entry(f) if item[:id]
	  username_entry(f) if item[:username]
	end
      end
      system(
             'tar',
             '--owner=nobody',
             '--group=nogroup',
             '-czf', output_filename,
             '--directory', dir,
             './metadata.json',
             './Vagrantfile'
      ) || raise("Failed to create box file")
    end
  end

end
