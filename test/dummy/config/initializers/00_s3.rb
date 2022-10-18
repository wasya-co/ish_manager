
::S3_CREDENTIALS ||= {
  :access_key_id => ENV['AWS_KEY_ID'],
  :secret_access_key => ENV['AWS_KEY_SECRET'],
  :bucket => "ish-development-contractors",
  :s3_region => 'us-east-1'
}
