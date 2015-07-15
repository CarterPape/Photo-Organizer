//
//  main.swift
//  Photo Organizer
//
//  Created by Carter Pape on 7/11/15.
//  Copyright (c) 2015 Carter Pape. All rights reserved.
//

import Foundation

let absSourceDir: String
let absDestinationSpace: String
if Process.arguments.count == 3 {
    absSourceDir = Process.arguments[1]
    absDestinationSpace = Process.arguments[2]
}
else {
    println("Bad argument count: \(Process.arguments.count - 1)\n" +
        "(we require 2: first, the source directory, and second, the destination space)")
    exit(1)
}

var fileManager = NSFileManager.defaultManager()
var fileEnumerator = fileManager.enumeratorAtPath(absSourceDir)

while let srcRelPath = fileEnumerator?.nextObject() as? String {
    let srcFile = FileBean(fileManager: fileManager,
        absPath: absSourceDir + srcRelPath)
    
    if srcFile.fileType != "NSFileTypeDirectory" && !srcFile.fileName.hasPrefix(".") {
        var destination = FileDestination(space: absDestinationSpace,
            date: srcFile.creationDate,
            originalFileName: srcRelPath.lastPathComponent)
        
        var fileMover = FileMover(srcFile: srcFile,
            destination: destination,
            fileManager: fileManager)
        
        fileMover.moveFileToDestination()
    }
}