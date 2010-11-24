Thread.abort_on_exception = true
class RubyAPI
  $LOGGER.info("Ruby API Initialized!")
end

Dir[File.join($SCRIPTDIR, "*.rb")].each do |file|
  next if file.match("init.rb$")
  $LOGGER.info("Ruby loading: #{file}")
  load file
end
