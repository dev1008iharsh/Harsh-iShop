# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'

target 'Harsh iShop' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Harsh iShop

 




  target 'Harsh iShopTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'Harsh iShopUITests' do
    # Pods for testing
  end


end

# Workaround for Cocoapods issue #7606
post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
        config.build_settings.delete('CODE_SIGNING_ALLOWED')
        config.build_settings.delete('CODE_SIGNING_REQUIRED')
    end
end