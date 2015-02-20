%w(static
    users
    sessions
    storybooks
    stories
    devise
    active_admin
    password_resets).each do |controller|
  Rails.application.config.assets.precompile += ["#{controller}.css", "#{controller}.js"]
end