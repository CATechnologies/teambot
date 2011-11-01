# Jenkins build status
#
# is it greeeeen?            - General status of the builds
# is it red?                 - Pessimist version of 'is it green'
# hubot build status         - Details build status

module.exports = (robot) ->
  robot.hear /is it (gr[e]+?n|red)/i, (msg) ->
    jenkinsRequest msg, (json) ->
      for job in json.jobs
        fail = true if job.color == 'red'

      if fail
        msg.send "Its RED!"
      else
        msg.send "Its GREEN!"

  robot.respond /[.+]?build status/i, (msg) ->
    jenkinsRequest msg, (json) ->
      for job in json.jobs
        if job.color == 'red'
          msg.send "#{job.name} is RED! #{job.url}"
        if job.color == 'blue'
          msg.send "#{job.name} is green."

jenkinsRequest = (msg, callback) ->
  domain   =  process.env.HUBOT_JENKINS_DOMAIN
  username =  process.env.HUBOT_JENKINS_USER
  password =  process.env.HUBOT_JENKINS_PASSWORD

  unless domain and username and password
    msg.send "Jenkins need some configuration to work."
    msg.send "Please set HUBOT_JENKINS_DOMAIN, HUBOT_JENKINS_USER and HUBOT_JENKINS_PASSWORD."
    return

  auth = 'Basic ' + new Buffer(username + ':' + password).toString('base64');

  msg.http("http://#{domain}/api/json")
    .headers(Authorization: auth, Accept: 'application/json')
    .get() (err, res, body) ->
      if err or res.statusCode != 200
        msg.send("Something went wrong with #{domain}.")
      else
        json = JSON.parse body
        callback(json)
