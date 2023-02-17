# Group Chat Application usign Flutter and Firebase

This is a Flutter and Firebase-based group chat application that allows users to login or sign up, create or search for groups, and communicate with other members of the group. The application has several features that make it easy for users to manage and participate in group conversations.

## Features

-Login and Signup: Users can login with their email and password or create a new account to start using the application.

-Create or Search for Groups: Users can create new groups or search for existing ones.

-Chatting: Once a user joins a group, they can send and receive messages. Each sender has their unique name color that differentiates them from other members.

-Group Info: Users can view group name, admin, and members from the group info page.

-Profile Page: Users can view their name and email on their profile page.

-Logout: Users can log out of the application by pressing the logout icon button.

-Leave a Group: Users can leave a group by pressing the leave group icon button or toggling the join button in the search page.

## Navigation

The following are the navigation paths to access the different parts of the application:

-Sign in and sign up pages: Users can access these pages when they launch the application.

-Home Page: Users can access the home page by successfully logging in or signing up.

-Group Info Page: Users can access the group info page by pressing the group name on the home pag.

-Profile Page: Users can access their profile page by a drawer on the home page.

-Logout: Users can log out by pressing the logout icon button accessed through the drawer.

## Authentication

-Firebase Authentication is used to verify that the user is logged in or signed up successfully. Once the user is signed in or up, they should be redirected to the home page even if they left or closed the application.
