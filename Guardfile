guard :bundler do
  require 'guard/bundler'
  require 'guard/bundler/verify'
  helper = Guard::Bundler::Verify.new
  files = ['Gemfile']
  # Assume files are symlinked from somewhere
  files.each { |file| watch(helper.real_path(file)) }
end

guard :rspec, cmd: 'bundle exec rspec' do
  watch(%r{^spec/(.*)_spec\.rb$})
  watch(%r{^lib/postal_code/(.+)\.rb$}) { |m| 'spec/postal_code/#{m[1]}_spec.rb' }
  watch(%r{^spec/spec_helper\.rb$}) { 'spec' }
end

guard :rubocop, all_on_start: false do
  watch(%r{.+\.rb$})
  watch(%r{(?:.+/)?\.rubocop\.yml$}) { |m| File.dirname(m[0]) }
end
