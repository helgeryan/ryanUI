# Ryan's UI Repository

## Descritption

This repository contains the code for the RyanUI SDK. The source files can be found under the directory `Source/RyanUI/`. 

Also contained in this repository is a test application that installs the SDK as a local Swift Package. This application is a tableView that allows you to implement a new row that presents a new UI feature.

Lastly, the repository contains files to distribute the RyanUI SDK as a Cocoapod. See below on how to distribute cocoapod on instructions for `Distributing Cocoapod`.

## Cloning repository

These are instructions on how to clone the repository locally.

1. Gain access to the private repository found here: https://github.com/helgeryan/ryanUI
2. Clone the repository using SSH.
    a. Follow the steps to create an SSH key: https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent
    b. Follow steps here to add your SSH key to you Github Account: https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account
    c. Go to the RyanUI Github site in step 1
    d. Press the green code dropdown button
    e. Select SSH
    f. Copy the url (should look like this: `git@github.com:helgeryan/ryanUI.git`)
    g. Open terminal in a folder directory of your choosing
    h. Run `git clone url-from-step-2f`
    
    NOTE: If error reach out to Ryan Helgeson
    
## Running the Test Application 

Instructions to run the application

1. Open the TestUIApp.xcodeproj in XCode 
2. Select the TestUIApp target
3. Choose a device to run on 
4. Command + Shift + R or hit the Play Button

## Distributing Cocoapod

How to distribute Cocoapod. 

1. Create a new commit 
    a. Update the podspec to a newer pod version
    b. Tag the commit using `git tag`
    c. Push the commit `git push`
    d. Push tags `git push --tags`
    
2. Push the RyanUI Cocoapod repository by: `pod repo push RyanUI RyanUI.podspec --allow-warnings`

NOTE: Add `--verbose` to get more logging reported.

