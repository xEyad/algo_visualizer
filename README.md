# algo visualizer
A simple algorithim visualizer to show you how every algorithim works under the hood to ease up understanding specfic algorithms.
Online demo link: https://xeyad.github.io/algo_visualizer

# project intent
In many cases if a developer needs to assess another developer skill, he can do so by checking out his previous works. However that might not be enough indicator to how that specific developer contributed to a large project. thus, This techinical demo shows the technical skill of it's author, since that it is made entirely by 1 person and the source code is checkable. 

This technical demo shows everything that you need to asses from code lens. like readability, architecture, modularity, etc, etc

# Building for web
run the auto build bat file 
Command: webBuildAndPublish.bat

or follow the steps below:
1. flutter build web --release --base-href /algo_visualizer/ 
1. copy contents of build/web to docs/
1. duplicate your index.html and rename it to 404.html
1. git push

# references
https://www.flutterclutter.dev/flutter/tutorials/create-a-controller-for-a-custom-widget/2021/2149/