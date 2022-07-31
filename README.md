# JSUFitness

## Table of Contents
1. [Overview](#Overview)
2. [Product Spec](#Product-Spec)
3. [Wireframes](#Wireframes)
4. [Database](#Database)

## Overview
### Description
JSUFitness is an iOS application that allows the JSU coaching staff and athletic team to communicate with each other.

### App Evaluation
- **Category:** 
- **Mobile:** 
- **Story:** 
- **Market:** 
- **Habit:** 
- **Scope:** Jackson State University

## Product Spec
### 1. User Stories (Required and Optional)
**Required Must-have Stories**
* User sign up, log in, log out
* Coach user can create a team
* Coach can add and delete members from team
* Coach can create a new meeting or new training
* Coach can approve or decline a absence from athletes
* Athlete can request to join a team
* Athlete can confirm a new meeting or new training notification from coach
* Athlete can make a absence request for centain training or meeting to coach
* User can update his/her profile like portrait image and nickname

**Optional Nice-to-have Stories**
* Dark mode
* Personalized Schedule (Coach)

### 2. Screen Archetypes
* Login 
* Register
* Schedule Page
* Notification Page
* Personal Profile

### 3. Navigation
**Tab Navigation** (Tab to Screen)
* Schedule
* Notification 
* Personal 

**Flow Navigation** (Screen to Screen)
* Login 
* Register
* Schedule Page
* Notification Page
* Personal Profile

## Wireframes
<img src="https://github.com/JSUFitnessiOSApp/FitnessiOSApp/files/8347185/Note.Mar.23.2022.pdf" width=800><br>

## Database
### Database EER Diagram
<img src="https://github.com/JSUFitnessiOSApp/FitnessiOSApp/files/8372720/EER.pdf" width=800><br>

### Database Design Schema
<img src="https://user-images.githubusercontent.com/35981611/160647963-86e61ec6-cf2a-4ad0-891c-7ce6ebef4d20.png" width=800><br>

## Networking
### List of network
* Sign up page
  * (Create/POST) Create a new user as athlete or coach
* Sign in page
  * (Read/GET) Sign up by username and password
* Schedule page
  * (Read/GET) query all schedule events for current user based on date
* New Event page
  * (Create/POST) create a new event
* Notification page
  * (Read/GET) query all unconfrimed events
* Profile page
  * (Read/GET) query current user object
  * (Update/PUT) Update current user portrait 
