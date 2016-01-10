# A simple slackbot for experiment

This bot is builded based on Sinatra and HTTParty by follow [this guide](http://www.sitepoint.com/building-a-slackbot-with-ruby-and-sinatra/).

Deployed to Heroku: `https://junior-bot.herokuapp.com`

Test command:

```
curl --data-urlencode 'text=issues_pddo/junior-bot' --data-urlencode 'trigger_word=abc' https://junior-bot.herokuapp.com/gateway
```
