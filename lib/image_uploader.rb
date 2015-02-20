class ImageUploader < CarrierWave::Uploader::Base

  include Cloudinary::CarrierWave

  options = { allowed_formats: ['jpg', 'gif', 'png'] }


end