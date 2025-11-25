# Interchange iOS

This is the iOS app codebase for Interchange, an app for college transit.

## Setup

You'll need Xcode 26.x to run the project.

Clone the [server repo](https://github.com/brendan-ch/project-inter-server) to
load the data necessary for this app. Follow the instructions there to set up the server.

Then, clone this repo and open a new terminal window. Navigate it to the project directory.

This project uses [Apollo iOS](https://www.apollographql.com/docs/ios), an open-source
GraphQL client for Swift applications. You'll need to install the Apollo CLI
for code generation when you make any changes to the GraphQL schema.

Follow these steps to install:

```bash
$ curl -L https://github.com/apollographql/apollo-ios/releases/download/1.3.3/apollo-ios-cli.tar.gz -o apollo-ios-cli.tar.gz
$ tar -xzf apollo-ios-cli.tar.gz
$ chmod +x apollo-ios-cli
```

To test the generation, run this to re-generate GraphQL type definitions in the form of a Swift package:

```bash
$ ./apollo-ios-cli generate
```
