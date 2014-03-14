class Fax < ActiveRecord::Base
  mount_uploader :fax, FaxUploader
end
