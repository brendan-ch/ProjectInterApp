# Interchange iOS

This is the iOS app codebase for Interchange, an app for college transit.

## Setup

You'll need to clone the [server repo](https://github.com/brendan-ch/project-inter-server) to
load the data necessary for this app. Follow the instructions there to set up the server.

Then, clone this repo and open a new terminal window. **Do not open the project in Xcode.**

This project uses [Apollo iOS](https://www.apollographql.com/docs/ios), an open-source
GraphQL client for Swift applications. Run this to install the Apollo CLI into 
the project directory:

```bash
$ curl -L $CLI_URL -o apollo-ios-cli.tar.gz
$ tar -xzf apollo-ios-cli.tar.gz
$ chmod +x apollo-ios-cli
```

Run the script to generate GraphQL type definitions in the form
of a Swift package:

```bash
$ ./apollo-ios-cli generate
```

Now, open the project in Xcode and package dependencies should resolve correctly.
