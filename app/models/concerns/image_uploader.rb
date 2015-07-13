class ImageUploader < Carrierwave::Uploader::Base

  include Cloudinary::CarrierWave

end