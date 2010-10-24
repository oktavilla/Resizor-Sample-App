class Asset < ActiveRecord::Base
  before_create :process_and_save_to_remote
  after_destroy :remove_from_remote
  
  attr_accessor :file

  class << self
    def resizor_api_key
      raise 'Resizor API-key is not set'
    end
    
    def resizor_endpoint
    "http://resizor.com"
    end
  end
  
  def url_for_size(size, format = 'jpg')
    "#{Asset.resizor_endpoint}/assets/#{resizor_id}.#{format}?size=#{size}&token=#{token_for_size(size, format)}"
  end
  
  def token_for_size(size, format = 'jpg')
    Digest::SHA1.hexdigest("#{Asset.resizor_api_key}-#{resizor_id}-#{size}-#{format}")
  end
  
protected
  def tmp_dir
    File.join(RAILS_ROOT, 'tmp/assets')
  end
  
  def tmp_path 
    File.join(tmp_dir, self.name)
  end
  
  def process_and_save_to_remote
    self.name = file.original_filename
    
    Dir.mkdir(tmp_dir) unless File.exists?(tmp_dir)
    if file.is_a?(Tempfile)
      FileUtils.move(file.local_path, tmp_path)
    else
      File.open(tmp_path, 'wb') { |f| f.write(file.read) }
    end
    File.chmod 0644, tmp_path
    
    save_to_resizor
  end
  
  def save_to_resizor
    raw = Nestful.post "#{Asset.resizor_endpoint}/assets.json", 
                    :format => :multipart, 
                    :params => {:api_key => Asset.resizor_api_key, :file => File.open(tmp_path)}
    ret = ActiveSupport::JSON.decode(raw)
    self.resizor_id = ret['asset']['id']
  end
  
  def remove_from_remote
    Nestful.post "#{Asset.resizor_endpoint}/assets/#{resizor_id}", 
              :params => {:api_key => Asset.resizor_api_key},
              :method => :delete
  end
  
end
