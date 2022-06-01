---
date: 2022-06-01 13:00
description: My experiences and contributions during my internship
tags: story, internship
author: Benny
---
# An internship of working on Vapor

## Context

So to start off with, I'll briefly introduce myself and I'll explain how I came to be working on Vapor. My name is Benny, I'm 24 years old and I'm studying Applied Computer Science at HOGENT in Belgium. Outside of that I was also the IT-manager for my student fraternity Heimdal. 

As part of my studies we were tasked with finding an internship to gain some real-world experience. Before I began on my search, my iOS teacher, Steven, sent us all a message telling us he had two opportunities to work with Swift in an open-source context and that he could bring us in contact with the people involved. That is how I came to talk to Tim, who's the founder of Broken Hands. We had an interview together and he told me he'd be glad to take me up as an intern. Eventually I decided to take the opportunity and do my internship at Broken Hands.

### Why this internship and not another?

The internship task was described as follows:

> *Helping with the development of the Vapor framework (https://vapor.codes) using the Swift programming language. Work may include implementing new features, fixing bugs, writing documentation, improving tests, integrating with external services for testing, standardising our CI/CD across multiple repos and building custom actions to automatically deploy new templates of Vapor apps. Everything will be open source. Other potential tasks include improving the tooling for server-side Swift in general. E.g. writing a Visual Studio Code plugin or a Swift version of Rustup. Interns can choose which tasks they work on. Students will be required to learn Swift before starting their internship. For more information, please contact your lecturer Steven before applying.*

As one might suspect, working in open source, being able to choose what you worked on. These all sounded very promising to a student. A possible downside of the internship was that it was fully remote. However I did eventually choose this job because of multiple factors. 

The biggest one was working in open-source. As a student or a new programmer, it can be very daunting to want to start in open source. You might not know where to start, you're afraid to contribute because everything is public, you feel like you having nothing to bring to the table, etc. These are all thoughts that at some point have crossed my mind as I'm sure it crosses many others as well. It was an opportunity for me to learn "how does contributing to open source actually work?". 

Another big factor was that the internship was entirely in Swift. Having just a semester of experience with Swift and having enjoyed using it, I wanted to get more experience in it.

## The internship

### Some statistics

During my internship I've done:  
- 30+ GitHub Issues  
- 160+ Pull Requests  
- 500+ Commits

### Projects

#### Blog website  
  
One of my first projects was working on the Blog site, the site you are on right now. This included some small things like adding a date and an author to the blog posts. But I've also added a 404 error page, automatic deployment to AWS by using GitHub Actions, adding CSP to the site and I've written a few blog posts.

#### Documentation website  
  
On the documentation website, I've added a 404 page and deployed the website to AWS. Next to that I have also added the i18n plugin that makes translating for the documentation a smoother experience as we don't need to create multiple repositories anymore per language.

#### Project boards  
  
One of the bigger project I've undertaken is the project boards. 
The assignment was to create a GitHub Action workflow that, on creation of an issue with the label 'good first issue' or the label 'help wanted', would create a project card on the corresponding project board.

To start this project off, I first went through the documentation of GitHub Actions to see which information we were getting on the creation of an issue. Following this it was a case of finding out how to create the project cards from this information. For this there was a marketplace action available made by [Alex Page](https://github.com/alex-page) that could automatically do this for us. Once we got this figured out, it was time to make the workflow reusable. This was needed as otherwise, we'd need to update every workflow in every repo that contains it if there's a mistake or change. For this, I've made a workflow that passes the labels on an issue to the reusable workflow. And behold, the project boards have come alive.

Since this workflow has been in place, the 'good first issue' issues project board has been halfway completed.

#### Template generation  
  
Another project entirely made in GitHub Actions that I've taken upon me was the automatic template creation. This was a suggestion made by Tim so people wouldn't have to install the toolbox to get a Vapor project created anymore. Overall this workflow was straightforward since the templates could be replaced easily. 

A harder part of this project was testing the template in a pull request. This is because GitHub Actions doesn't allow some actions when they come from a fork as they may be malicious code. For this I've had to extract the source repository of the pull request. Once we had the information of where the source came from, we needed to create 2 steps that so almost exactly the same. However creates a template from a branch, where the other creates the template from the fork. If in any of the cases, the template fails to generate, then the PR cannot be accepted. This makes sure that every template that is generated, is actually able to generate without problems.

#### Penny discord bot  
  
My biggest project during the internship was working on Penny. Penny is a discord bot that gives coins when people help each other. There were some issues with Penny however. The issues were as followed:  
* no database backups which has led to lost data
* The code behind penny is running on Vapor 3, which is legacy at this point in time.
* Penny stops working from time to time

So I was tasked with re-creating Penny from scratch.

##### The API  
  
A decision made for the new Penny bot, was that our API would be hosted on AWS with AWS Lambda Functions. This because it's cost effective and it scales when needed. To achieve this, I got on working with `swift-aws-lambda-runtime`. The great advantage of this package, was that we were able to test our lambda function locally. Once the request worked locally, it was time to upload it to AWS. At the time however, the docker image for Swift 5.6 was not officially released yet, and the AWS Lambda functions worked with an x86 architecture, which meant I had no way to build the lambda function on my local M1 mac. To resolve this issue, I've created a workflow that builds the application and automatically deploys it to the AWS Lambda function. Once the lambda function worked online as well, then it was time to do the next step.

##### The database  
  
Coming from a PostgreSQL database, the plans were to move to dynamoDB as out schema was not that complicated. This started by thinking about how the model should look. Once the model was set up, it was time to create a local DynamoDB database in Docker. This could be used for testing the data handling of our API functions. Once this was done we could create our online database and test that with our API.

One thing I needed to figure out was how to convert the data from the PostgreSQL database to the DynamoDB model. For this I've created a program that migrates the data to the new database. This was tested with the local DynamoDB.

##### The Bot  
  
To create the bot, and to make full use of discord's features, I had chosen to use [Swiftcord](https://github.com/SketchMaster2001/Swiftcord). By doing this, it was easy to create the bot itself. At the time of writing however, there are still some issues with the bot staying online. Hence this isn't in use yet.

#### Vapor  
  
Outside of the other projects, I was also able to contribute to Vapor. This included writing tests and fixing bugs. In these were adding an international email validator, fixing an issue with unicode characters in filenames, improving debug errors and fixing an issue where streaming a video on Safari from a Vapor backend stopped working. 

## My experience

### What I've learned

Through this internship, my experience with Swift has definitely grown. I've learned to use the language better and I've learned about debugging possibilities in Xcode. I've also learned how to work with AWS and GitHub Actions, two technologies that I hadn't used beforehand.

More importantly I've learned how to work in open source development. Forks, Pull Requests, Reviews, etc are all concepts that are familiar to me now and I'd say that now I wouldn't have major issues contributing to open source.

### Working for Broken Hands

The internship was fully remote, which can be a point of doubt for students when it comes to getting support. However Tim was a great mentor who took the time to help me when I needed it. Outside of that, I managed to meet Tim in person thanks to him inviting me along to Swift Heroes in Italy.

I thank Tim from the bottom of my heart for all the support and mentoring he gave. I also recommend students to contribute to open source if they are interested and I will continue to contribute to Vapor when I can.
