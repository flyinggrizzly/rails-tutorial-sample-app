if Rails.env.test?
  CarrierWave.configure do |conf|
    conf.enable_processing = false
  end
end
