#
# Listens for GitHub webhooks events
#

argv = require('optimist')
  .default('port', 3240)
  .demand('repo')
  .describe('repo', 'comma-separated list of repos')
  .default('branch', 'production')
  .argv

repos = argv.repo.split ','

spawn = require('child_process').spawn
githubhook = require('githubhook')

github = githubhook
  port: argv.port
  logger:
    log: (data) ->  console.log '*', data
    error: (data) -> console.error '!', data


github.listen()


for repo in repos
  console.log "= watching for repo '#{repo}'"
  github.on "push:#{repo}:refs/heads/#{argv.branch}", (data) ->
    console.log '= commit:', data.commits[0].message
    gitrun = spawn './run-git.sh', [repo, argv.branch]
    gitrun.stdout.on 'data', (data) ->
      console.log '' + data

    gitrun.stderr.on 'data', (data) ->
      console.log '(!) ' + data

    gitrun.on 'close', (code) -> console.log "Done (#{code})."



