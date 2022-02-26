@ECHO OFF
ECHO Building project for web and publishing to git
ECHO flutter build web --release --base-href /algo_visualizer/ 
flutter build web --release --base-href /algo_visualizer/ 

ECHO copy contents of build/web to docs/
xcopy "build/web" "docs/" /y

ECHO duplicate your index.html and rename it to 404.html
xcopy "docs/index.html" "docs/404.html" /y

ECHO git add and commit all with message "new web version"
git add .
git commit -m "new web version"

ECHO git push
git push

ECHO Congrats, everything is ready. updates should appear on this link https://xeyad.github.io/algo_visualizer within few short minutes 
PAUSE