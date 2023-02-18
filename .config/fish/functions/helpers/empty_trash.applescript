on run {}
  tell application "Finder"
   set variable to count of items of the trash
   If variable > 1 then
     empty trash
   End if
  end tell
end run