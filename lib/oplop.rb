require 'digest/md5'
require 'base64'

module Oplop

  LENGTH = 8

  #
  # Oplop.password(:master => 'p@ssw0rd', :label => 'github')
  #
  def self.password(args={})
    unless (args.keys.include?(:master) && args.keys.include?(:label))
      raise ArgumentError.new 'Master and label are required arguments.'
    end
    
    master_label = '%s%s' % [ args.delete(:master), args.delete(:label) ]
    
    raise ArgumentError.new "Unknown keys #{args.keys.join(',')}." if args.keys.any?
    

    password = urlsafe_b64encode(Digest::MD5.digest(master_label))
    
    if password.respond_to?(:encode)
      password = password.encode('UTF-8')
    end
    
    if m = password.match(/\d+/)
      password = '%s%s' % [ m[0], password ] if (m.begin(0) >= LENGTH)
    else
      password = '1%s' % password
    end
    
    password[0,LENGTH]
  end

  # See http://www.ietf.org/rfc/rfc4648.txt
  # Ruby 1.8.x does not have this as part of the Base64 lib
  def self.urlsafe_b64encode(string)
    Base64.encode64(string).tr('+/', '-_')
  end

end
