require 'image_optim'

module CarrierWave
  module MiniMagick
    def quality(percentage)
      manipulate! do |img|
        img.quality(percentage.to_s)
        img = yield(img) if block_given?
        img
      end
    end
  end
end

module CarrierWave
  module ImageOptim
    extend ActiveSupport::Concern

    @@io = ::ImageOptim.new(pngout: false)
    module ClassMethods
      def compress
        process :compress
      end
    end

    def compress
      cache_stored_file! if !cached?
      @@io.optimize_image!(current_path)
    end
  end
end
