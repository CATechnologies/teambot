# That's what she said
# The most versatile joke on Earth. Ideal for robot.
#
# Observe a list of word and shoot the quote, only once a day.
#
#

module.exports = (robot) ->

  words = ['long', 'short', 'big', 'hard']
  regex = new RegExp(words.join('|'), 'i')
  self = @

  robot.hear regex, (msg) ->
    if self.that_what_she_said
      if (new Date().getTime() - self.that_what_she_said) < 86400000
        return
      else

    self.that_what_she_said = new Date().getTime()
    msg.send "THAT'S WHAT SHE SAID!!"