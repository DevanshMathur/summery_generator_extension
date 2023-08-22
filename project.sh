echo "Select one of the following option to execute appropriate tasks"
echo "1 - Clean Build"
echo "2 - Run Build Runner"
echo "3 - Clean Build and Run Runner"
echo "4 - Undo last commit"

read "choice"

cleanBuild() {
  flutter clean
  flutter pub get
}

runBuildRunner() {
  cleanBuild
  flutter pub run build_runner build --delete-conflicting-outputs
}

runBuildRunnerWithClean() {
  cleanBuild
  runBuildRunner
}

undoLastCommit() {
  git reset HEAD~1 --soft
}

buildWebExtension() {
  flutter build web --web-renderer html --csp
}

if [ -z "$choice" ];then
    echo "choice cannot be null"
    exit 1
fi
if [ "$choice" == 1 ];then
    cleanBuild
elif [ "$choice" == 2 ];then
    runBuildRunner
elif [ "$choice" == 3 ];then
    runBuildRunnerWithClean
elif [ "$choice" == 4 ];then
    undoLastCommit
elif [ "$choice" == 5 ];then
    buildWebBuild
else
    echo "Invalid choice"
    exit 1
fi

<<com

 For Web
 flutter config --no-enable-web

 For desktop
 flutter config --no-enable-windows-desktop
 flutter config --no-enable-macos-desktop
 flutter config --no-enable-linux-desktop

com
