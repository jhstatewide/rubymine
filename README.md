RubyMine
====================================

* **Homepage**:     [http://github.com/jhstatewide/rubymine](http://github.com/jhstatewide/rubymine)
* **Git**:          [http://github.com/jhstatewide/rubymine](http://github.com/jhstatewide/rubymine)
* **Author**:       Joshua Harding
* **Copyright**:    2010
* **License**:      GPL
* **Latest Version**: 0.1
* **Release Date**: November 23th 2010

Synopsis
--------

RubyMine is a plugin for [hey0's mod](http://forums.hey0.net) for [Minecraft](http://minecraft.net).
This plugin allows you to create other plugins with [JRuby](http://jruby.org).

Ruby is an object oriented scripting language and I find it much more interesting than
Java.

Installation
------------
* Copy lib/jruby.jar and the dist/RubyMine.jar.
* In your plugins directory, create a ruby directory.
* Place init.rb and any other wanted ruby plugins into the plugins/ruby directory.
* Launch your hey0 mod equipped Minecraft server and enjoy the Ruby goodness.

Project Status
--------------
Currently the plugin provides 3 globals to the integrated JRuby interpreter.
* $LOGGER
* $SERVER
* $ETC

All of the API exposed through hey0 should now be accessible through the Ruby
interpreter.

Example Ruby Plugins
--------------------
There is a time announcer in example_plugins.
Every 60 seconds, this plugin announces the time to your players.
Not useful, but a proof of concept.

TODO
----
* More documentation.
* More example plugins.
* Support for loading rubygems.