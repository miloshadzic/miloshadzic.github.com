task :default do
  `jekyll`
end

desc 'Clean the output dir'
task :clean do
  rm_rf('_site')
end

desc 'Recreate the site and serve. Autoregeneration is ON'
task :serve do
  `jekyll --serve --auto`
end

task :reading do
  `erb reading.html.erb > reading.html`
end

task :serve => [:reading]
