# A Simple Slackbot

The repo is for personal experiment only.

## Deployment

This bot is builded based on Sinatra and HTTParty by following [this guide](http://www.sitepoint.com/building-a-slackbot-with-ruby-and-sinatra/).

Deployed to Heroku: `https://junior-bot.herokuapp.com`

Test command:

```
curl --data-urlencode 'text=issues_pddo/junior-bot' \
--data-urlencode 'trigger_word=abc' \
--data-urlencode 'token=[slack token]' \
https://junior-bot.herokuapp.com/gateway
```

## Create a scheduler by `/remind` command of Slack

Syntax to create reminder: 

    /remind [channel or user] to [bot keyword] [bot command] at [time description]

Ex: 

    /remind #general to junior issues_pddo/junior-bot at 11:38pm every Sunday

Then should include this keyword: `Reminder: [bot keyword]` alongs with main bot keyword to outgoing WebHooks of Slack.  
Ex: `Reminder: junior`
