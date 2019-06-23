# simple-words

A small Slack app that runs on an AWS Lambda.
Configures a channel to disallow messages containing any words not on [this list](words.txt).
Adapted from [this discord bot](https://gist.github.com/lynn/aeea4fdd057cfa5396a7f2923280a810/) by [@lynn](https://github.com/lynn).

![an example of the app deleting a message for using the words "concept", "ridiculous", and "nonsensical"](media/example.gif)

## Setup
### Prerequisites

Before installing, you will need:

- A Slack workspace you administrate, and a channel to host the app
- An AWS account to install the app into
- An AWS S3 artifact bucket to load the code into

---

To start, create a new Slack App for your workspace.
We'll return to configure it later, but for now install it and fetch its OAuth Access Token.

### AWS
Now run `deploy.sh`, with the following positional arguments:

- a name for your CloudFormation stack
- the name of the S3 bucket you'll be packaging your code artifact to
- the name of the channel you want your app to watch, eg `#simple-words`
- your app's OAuth access token, eg `xoxp-9999999999-...`

Note that the last two arguments are only required once per stack.

The last line of the script's output will be your application's webhook url.
Hold onto this for the next steps.

### Slack
Return to your Slack app, and grant it the following permissions:

- `chat:write:user`, to allow it to delete user messages
- `admin`, to allow it to delete user messages it didn't itself write
- `channels:history` to allow it to view messages
- `chat:write:bot` to allow it to send ephemeral messages letting users know what words caused their messages to be deleted

Create an Event Subscription using your webhook url, and subscribe to the `message.channels` event.
This will allow the app to act in response to any message.

That's it! Enjoy having very simple talking times.
