watchmedo shell-command --patterns="*.h;*.m" \
                        --recursive \
                        --command="xcodebuild test -workspace NymbolKit.xcworkspace -scheme NymbolKit -sdk iphonesimulator7.1 | xcpretty -c"\
                        .
