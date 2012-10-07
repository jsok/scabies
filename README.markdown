Scabies -- The Bug Tracker
====================

Introduction
---------------------
A simply bug tracker I wrote over a couple of days.
An hommage to the scabies mite, may your bugs be easier to fix than killing scabies.

Setup
---------------------
git clone git://github.com/sokjon/scabies.git
cd scabies
bundle install
rake db:migrate
rails server
open localhost:3000

And you're done! Signup a new user and start a project to file bugs in.

Requirements
---------------------
*   rails 3.
*   state_machine
*   ruby-graphviz (if you want to viz your state machine)
*   RedCloth

Features
---------------------
*   Ability to maintain multiple projects.
*   Each project is private until the creator/admin adds other users.
*   RedCloth markup available in bug comments/discussion.

Bug States
---------------------
state_machine has been used to enforce a pattern of workflow:

![Bug State Machine](https://github.com/jsok/scabies/raw/master/state_machine.png)
