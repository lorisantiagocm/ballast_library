# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = "1.0"

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.
Rails.application.config.assets.precompile += %w[ popper.min.js material-dashboard.min.js bootstrap.min.js perfect-scrollbar.min.js smooth-scrollbar.min.js chartjs.min.js nucleo-icons.css material-dashboard.css?v=3.2.0 nucleo-svg.css favicon.png apple-icon.png]
