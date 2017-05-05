if Rails.env.production?
  CarrierWave.configure do |conf|
    conf.fog_credentials = {
      # Config for GCP
      :provider                         => 'Google',
      :google_storage_access_key_id     => ENV['GCP_ACCESS_KEY'],
      :google_storage_secret_access_key => ENV['GCP_KEY_SECRET']
    }
    conf.fog_directory = ENV['GCP_BUCKET']
  end
end
