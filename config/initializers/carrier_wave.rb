if Rails.env.production?
  CarrierWave.configure do |conf|
    conf.fog_credentials = {
      # Config for GCP
      :provider                         => 'Google',
      :google_storage_access_id_key     => ENV['GCP_ACCESS_KEY'],
      :google_storage_secret_access_key => ENV['GCP_KEY_SECRET']
    }
    config.fog_directory = ENV['GCP_BUCKET']
  end
end
