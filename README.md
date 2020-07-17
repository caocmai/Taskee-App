# Taskee App
Taskee is an app that the user can create and modify projects along with their tasks. 

## Description
This is a to-do type app that allows users to create and modify parent and child objects. More specifically for this app, the parent object is called Project, where the user can create and manipulate. The child of the Project object is called the Task object, which the user can also create and manipulate. 

Core Data is used to persistently store user created data, meaning data will not be lost when the user terminates the application intentionally or by accident. 

### Features 
* CRUD(Create, Read, Update, and Delete) plus Search projects 
* CRUD(Create, Read, Update, and Delete) tasks of projects with ability to toggle between pending and completed
* Edit a project/task by 3D touch (context menu)
* Core Data to persist projects and tasks 

### Usage
The user can create a project by giving it a name and color of their choosing to make the project easier to differentiate between them. 

The user can then create tasks for that project by giving it a title, image and due date.

### Run Locally
Project code can be viewed locally and run in Xcode's simulator by [cloning](https://github.com/caocmai/get-news-app.git) or downloading this repo.

## Built With
* [Xcode - 11.3.1](https://developer.apple.com/xcode/) - The IDE used
* [Swift - 5.1.4](https://developer.apple.com/swift/) - Programming language

## Author
* Cao Mai - [portfolio](https://www.makeschool.com/portfolio/Cao-Mai)

## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details
