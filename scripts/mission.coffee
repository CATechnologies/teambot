# Manage one's mission from Talker
# by Jack Bach <jackjackbach@gmail.com> and Jordi Romero <jordi@jrom.net>
#
# Commands:
# - my mission is <SOMETHING>
# - <hubot> what's my mission
# - <hubot> show all missions

compareDates = (date1, date2)->
  date1.getDate == date2.getDate and date1.getMonth == date2.getMonth and date1.getYear == date2.getYear

module.exports = (robot) ->
  robot.hear /my mission is (.*)/i, (msg) ->
    mission = msg.match[1]
    username = msg.message.user.name
    if user = robot.userForName username
      user.mission =
        message : mission
        date : Date.now()

      msg.send "Ok @#{username}, got your mission for today."
    else
      msg.send "I don't know who #{username} is"

  robot.respond /what's my mission/i, (msg) ->
    username = msg.message.user.name
    user = robot.userForName username
    if user
      mission = user.mission
      if mission && compareDates(new Date(mission.date), new Date)
        msg.send "@#{username} your mission for today is: #{user.mission.message}"
      else
        msg.send "@#{username} you don't have a mission yet"
    else
      msg.send "I don't know who @#{username} is"

  robot.respond /show all missions/i, (msg) ->
    for own key, user of robot.brain.data.users
      if user.mission and compareDates(new Date(user.mission.date), new Date)
        response  = "@#{user.name}'s mission for today is: "
        response += "#{user.mission.message}"
        msg.send response
