# Taskee App
Taskee is an app where the user can create and modify projects along with their tasks. 

## Description
This is a to-do type app that allows users to create and modify project and task objects. This app essentially allows users to create and modify parent and child objects with a one-to-many relationship. More specifically, the parent object is the project and its children are the task objects. There can be multiple projects and each project can have multiple tasks. 

Core Data is used to persistently store user-generated content, meaning their projects and tasks will not be lost when the application is purged from memory intentionally or by accident. 

### Features
* CRUD(Create, Read, Update, and Delete) plus ability to search projects 
* CRUD(Create, Read, Update, and Delete) tasks with ability to toggle between pending and completed
* Empty field validation 
* Edit/update a project or task that is accessible by 3D touch (context menu)
* Core Data to persist projects and tasks
* Local notification with text and image at a user's specfied time (must put app in background or lock screen to see notifications)

### App Demo (gif)
Version 1.5 <br>
![](Project%20Gif/Taskee2.gif)

### Usage
The user can create a project by giving it a name and color to make projects easier to differentiate between them. 

The user can then create tasks for that project by giving them a title, image, and due date. These tasks can then be marked as completed by a tap gesture.

### Run Locally
Project code can be viewed locally and run in Xcode's simulator by cloning or downloading this [repo](https://github.com/caocmai/taskee-app.git).

## Built With
* [Xcode - 11.3.1](https://developer.apple.com/xcode/) - The IDE used
* [Swift - 5.1.4](https://developer.apple.com/swift/) - Programming language

## Author
* Cao Mai - [Portfolio](https://www.makeschool.com/portfolio/Cao-Mai)

## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details

## Note
Camera functionality on the new task view only works on a physical device, meaning when the app is loaded and running on an actual physical Apple iOS device. Hence, the app will crash when trying to access the camera on a simulated device in Xcode.

## Previous Iteration
Version 1.0 <br>
![](Project%20Gif/Taskee1.gif)
