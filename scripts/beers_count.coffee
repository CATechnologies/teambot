# Keep track of the beer count for our alcohol based reward system
# Break the test? loose a beer! Fix an obscure bug? get a beer!
#
# <user> beers count + 1
# <user> beers count - 1
# give me <user> beers count

module.exports = (robot) ->
  robot.respond /(\w+)\sbeer.+\s(-|\+)[.+]?(\d+)/i, (msg) ->
    name = msg.match[1]
    operator = msg.match[2]
    modifier = parseInt(msg.match[3])

    return if modifier == 0

    if modifier > 1
      msg.send "#{operator}#{modifier} beers for #{name}"
    else
      msg.send "#{operator}#{modifier} beer for #{name}"

    if modifier > 5
      msg.send "#{operator}#{modifier}?! its not serious... that's too many beers."
    else if user = robot.userForName name
      count = if user.beer_count then user.beer_count else 0
      count = if operator == '+' then count+modifier else count-modifier

      user.beer_count = count
      msg.send "#{name} beers count is now at #{count}"
    else
      msg.send "Wait, who's #{name} anyway?"

  robot.respond /give\sme\s(\w+)\sbeers?\scount/i, (msg) ->
    if user = robot.userForName msg.match[1]
      msg.send "#{user.beer_count} for #{user.name}"
