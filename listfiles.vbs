Option Explicit

' Configuration
Dim strSharePath : strSharePath = "\\VBB-Toreon\SMBShare"  ' Change this to your share path
Dim strOutputFile : strOutputFile = "file_list.txt"        ' Output file

' Main execution
Dim objFSO, objOutputFile
Set objFSO = CreateObject("Scripting.FileSystemObject")

' Create output file
Set objOutputFile = objFSO.CreateTextFile(strOutputFile, True)

' List files recursively
ListFiles strSharePath, objOutputFile

objOutputFile.Close
WScript.Echo "File listing completed. Results saved to " & strOutputFile

' Recursive function to list files
Sub ListFiles(strPath, objFile)
    On Error Resume Next

    Dim objFolder, objSubFolder, objFileItem
    Set objFolder = objFSO.GetFolder(strPath)

    ' List files in current folder
    For Each objFileItem In objFolder.Files
        objFile.WriteLine objFileItem.Path
    Next

    ' Recurse into subfolders
    For Each objSubFolder In objFolder.SubFolders
        ListFiles objSubFolder.Path, objFile
    Next
End Sub
