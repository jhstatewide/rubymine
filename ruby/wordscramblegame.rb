require 'java'

class String
  def scramble
    s = self.split(//).sort_by { rand }.join("")
    s =~ /[A-Z]/ && s =~ /[a-z]/ ? s.capitalize : s
  end

  def scramble_words
    ret = []
    self.split(/\s+/).each { |nws|
      nws.scan(/^(\W*)(\w*)(\W*)$/) { |pre, word, post|
        ret << pre + word.scramble + post
      }
    }

    ret.join " "
  end
end

class WordScrambleGameListener < Java::PluginListener

  attr_accessor :handler

  # public boolean onCommand(Player player, String[] split)
  def onCommand(player, strings)
    command = strings.to_a.join(" ")
    $LOGGER.info("Command is: #{command.inspect}")
    if command == "/scramble start"
      handler.handle_game_start(player)
      return true
    end
    return false
  end

  def onChat(player, string)
    # ok, so if the game is running we want to see what everyone says!
    if handler.gamestate == :running
      $LOGGER.info("Evaluating #{string} from #{player.name}")
      handler.evaluate_match(string, player)
    end
    return false
  end

end

class WordScrambleGame < Java::Plugin
  GAME_DURATION = 60

  attr_accessor :gamestate, :scrambled_string, :solution, :scores, :wordlist

  def evaluate_match(string, player)
    if string.match(self.solution)
      # the player guessed it!
      add_score(player)
      # now pick a new word!
      $SERVER.message_all(Java::Colors::Green + "#{player.name} successfully guessed the answer!")
      pick_random_word()
    end
  end

  def add_score(player)
    # see if we are already in the scores table!
    if self.scores.key?(player)
      self.scores[player] += 1
    else
      # we didn't exist
      self.scores[player] = 1
    end
    $SERVER.message_all(Java::Colors::Green + "#{player.name} now has #{self.scores[player]} points!")
  end

  def handle_game_start(player)
    if gamestate == :idle
      $SERVER.message_all(Java::Colors::Rose + "#{player.name} started a match of scramble!")
      self.gamestate = :running
      self.scores = Hash.new
      # start thread that ends game
      Thread.new do
        sleep GAME_DURATION
        do_countdown(10)
        handle_game_stop()
      end
      # pick random word
      pick_random_word()
    end
  end

  def pick_random_word
    self.solution = self.wordlist[rand(self.wordlist.length)-1]
    # now scramble the word
    self.scrambled_string = self.solution.scramble_words
    $SERVER.message_all(Java::Colors::Rose + "The scrambled word is #{self.scrambled_string}! Say the answer!")
  end

  def congradulate_winner()
    highscore = 0
    winning_player = nil
    self.scores.each_pair do |player, score|
      $LOGGER.info("Looking at #{player.name}'s score of #{score}")
      if score > highscore
        $LOGGER.info("It's the high score!")
        winning_player = player
        highscore = score
      end
    end
    unless winning_player == nil
      $SERVER.message_all(Java::Colors::Green + "#{winning_player.name} won the match with #{highscore} points!")
    end
  end

  def handle_game_stop()
    $SERVER.message_all(Java::Colors::Rose + "Scramble has now ended!")
    congradulate_winner()
    self.gamestate = :idle
  end

  def do_countdown(n)
    secs_left = n
    n.times do |i|
      $SERVER.message_all("#{secs_left - i} seconds left!!!")
      sleep 1
    end
  end

  def reset
    self.gamestate = :idle
  end

  def load_words
    self.wordlist = IO.readlines(File.join($SCRIPTDIR, "wordscramble_words.txt"))
    self.wordlist.map! {|s| s.chomp}
    $LOGGER.info("The scramble wordlist: #{self.wordlist.inspect}")
  end

  def start
    load_words()
    @listener = WordScrambleGameListener.new
    @listener.handler = self
    $LOGGER.info("Word Scramble Initialized!")
    Java::etc.getLoader().addListener(
      Java::PluginLoader::Hook::COMMAND,
      @listener,
      self,
      Java::PluginListener::Priority::HIGH)

    Java::etc.getLoader().addListener(
      Java::PluginLoader::Hook::CHAT,
      @listener,
      self,
      Java::PluginListener::Priority::HIGH)
    reset
  end

end

word_scramble_game = WordScrambleGame.new
word_scramble_game.start