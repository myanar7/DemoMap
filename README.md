# DemoMap

## Overview

Application Preview: https://www.youtube.com/shorts/2sZndws9Fc4

This application is created by using MapKit and UIKit for iOS mobile devices. 

## About Project

In the project, MVP design pattern is used. Here is a folder order to understand how the classes implemented:

### Scenes

Scene

&nbsp;&nbsp;&nbsp;&nbsp;|-> View

&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|-> ViewController.swift

&nbsp;&nbsp;&nbsp;&nbsp;|-> Model

&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|-> Model.swift

&nbsp;&nbsp;&nbsp;&nbsp;|-> Presenter

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|-> Presenter.swift

As you can see in the hierarchy, Scene folder contains the pages in the application. Each view controller has its own scene folder. UI-related events handled in the View/ViewController.swift file. Each view controller has a Presenter object which decides the flows and actions for action in the view controller. Presenter stores model to keep data which will be used in the page. If presenter is able to send service request, it can have Service class. 

### Services

Service

&nbsp;&nbsp;&nbsp;&nbsp;|-> Base

&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|-> Service.swift

&nbsp;&nbsp;&nbsp;&nbsp;|-> CustomService.swift

&nbsp;&nbsp;&nbsp;&nbsp;|-> AnotherCustomService.swift

Service classes are inherited from Service.swift which handles the request and response. Custom classes does not need to handle about network connection, only need to have http method, endpoint and how the presenter will handled the data taken. 

### Utils

In the util folder, There are the extensions of some classes to make easier to read. LocationManager object is also in the utils folder. LocationManager is a singleton pattern to access iOS CLLocationManager.

## About the Code

In the code, all layouts of the views are set programatically. I believe that it demonstrates the profiency in the iOS SDK :) The summary of the flow is viewcontroller has a presenter and presenter has an model. ViewController recognize an event and ask presenter to take action. Presenter decide the action and notify the ViewController with the Delegate protocol assigned. And ViewController draws the UI and shows the decided action to the user. Responsibilities of the classes keep seperated as much as it can.

![MVP Architecture](https://media.geeksforgeeks.org/wp-content/uploads/20201024233154/MVPSchema.png)

`viewDidLoad(_)` of ViewController contains setup methods of the views. Private extension is used to make more readable by having setup methods in it. Each setup method implement the constraints, delegate assignment and other configuration for that view. If the view has a delegate, it is defined in the extension for it.

Presenter send request if it needs. And according to the result of service response, handles the data for the action.



## Unit Test

In the unit test folder, the specific methods tested in the unit test of XCTest. I couldn't completed that and UI Test for the app because of lack of time yet.











