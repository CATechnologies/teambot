# Deploy commands
#
# what hasn't been deployed  - General status of the builds

module.exports = (robot) ->
  robot.hear /what hasn't been deployed/i, (msg) ->
    checkDeployedVersion msg, (json) ->
      msg.send "This hasn't been deployed:"
      msg.send json

checkDeployedVersion = (msg, callback) ->
  deployed_sha_file   =  process.env.HUBOT_DEPLOYED_SHA_FILE
  repo_url   =  process.env.HUBOT_DEPLOYED_REPO_URL
  branch   =  process.env.HUBOT_DEPLOYED_BRANCH

  unless deployed_sha_file and repo_url and branch
    msg.send "Please set HUBOT_DEPLOYED_SHA_FILE HUBOT_DEPLOYED_REPO_URL AND HUBOT_DEPLOYED_BRANCH."
    return

  msg.http(deployed_sha_file)
    .get() (err, res, body) ->
      if err or res.statusCode != 200
        msg.send("Something went wrong with #{deployed_sha_file}.")
      else
        sha = body.replace(/^\s+|\s+$/g, '' )
        compare_link = "#{repo_url}/compare/#{sha}...#{branch}"
        callback(compare_link)
