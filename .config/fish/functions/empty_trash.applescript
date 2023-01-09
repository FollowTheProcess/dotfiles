tell application "Finder"
   set my count to count of items of the trash
   If my count > 1 then
     empty trash
   End if
end tell
