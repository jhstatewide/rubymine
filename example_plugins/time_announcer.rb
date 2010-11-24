# original Java:
#   for (Player p : etc.getServer().getPlayerList()) {
#			p.sendMessage(message);
#		}

$LOGGER.info("Time Announcer Loaded!")

Thread.new do
  while true do
    $SERVER.getPlayerList().each do |player|
      player.sendMessage("The current time is: #{Time.new.to_s}")
    end
    sleep 60
  end
end