# Junior Slackbot

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

- Install [Heroku toolbelt](https://toolbelt.heroku.com/)


## Create a scheduler by `/remind` command of Slack

Syntax to create reminder: 

    /remind [channel or user] to [bot keyword] [bot command] at [time description]

Ex: 

    /remind #tech24 #lunch send at 10:25 AM every weekday
    /remind #tech24 #lunch menu at 09:00 AM every weekday

Then should include this keyword: `Reminder: [bot keyword]` alongs with main bot keyword to outgoing WebHooks of Slack.  
Ex: `Reminder: junior`

## Lunch Command

- Show help: `#lunch <whatever>`

- Show menu: `#lunch menu`
  Show list of dishes which has format as:

```
1. Com dat ngoai
2. My xao bo
3. Beefsteak
4. Hu tieu
```

- Order a dish: `#luch order 3`
  Order `bittet` for calling user

- Cancel an order: `#luch cancel`
  Cancel any orderred dish of calling user

- Send mail to make order: `#lunch send request`

- Cancel all: `#luch clear`
  This command only effects for configurated users
