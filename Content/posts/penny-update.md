---
date: 2023-05-16 20:00
description: Penny Update - Keep Up With Swift's Evolution
tags: penny, bot, discord
author: Mahdi
authorImageURL: /author-images/mahdi.jpg
---
# Penny

We just released yet another update for [Penny](https://github.com/vapor/penny-bot) - our beloved Discord bot - and she now keeps you updated on Swift's evolution.    
Anytime there is a proposal change, Penny will post a message in the [#swift-evolution](https://discord.gg/vapor) channel so you don't fall behind on the news.   
Small Bonus is, you can receive all the updates on your own server! Just go to #swift-evolution and click the "Follow" button.

## Some Story
For a long time, Penny used to have problems giving coins to members.   
That wasn't good because how else were we supposed to pay another helpful member when they've shown us a solution which would have otherwise took us hours or days to figure out!?   
That's exactly why Tim and Benny started working on rewriting Penny and updating it with all the recent advancements the Server-Side Swift community has made.    
It was 9 months ago that I noticed Tim mention Penny is having problems staying connected to Discord Gateway. Long story short, I released [DiscordBM](https://github.com/MahdiBM/DiscordBM) for this reason.   
DiscordBM helped us get Penny rolling and now she's been working pretty nicely for the last 8+ months.   

## How is she looking right now?
Penny uses an automated process for deployments. Whenever there is an update to Penny's repository, the CI will:
* Run the tests to make sure Penny will work as intended. 
* Upload Penny's lambda functions to AWS.
* And at last, deploy her on AWS ECR.

We still have a lot in mind for Penny, but for now she can:
* Intelligently grant coins to members when they thank each other.
* Ping members when a keyword is used, like Slackbot.
* Manage sponsor/backer status of Github users.
* And as of today, keep you updated on Swift's evolution.

Keep an eye out for the upcoming features. You might find some sneak peaks on the [Github repository](https://github.com/vapor/penny-bot) 😉
