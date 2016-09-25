//
//  main.swift
//  Photo Organizer
//
//  Created by Carter Pape on 7/11/15.
//  Copyright (c) 2015 Carter Pape. All rights reserved.
//

import Foundation

var absSourceDir: String
var absDestinationSpace: String

if CommandLine.arguments.count == 3 {
    absSourceDir = CommandLine.arguments[1]
    absDestinationSpace = CommandLine.arguments[2]
}
else {
    print("Bad argument count: \(CommandLine.arguments.count - 1)\n" +
        "(we require 2: first, the source directory, and second, the destination space)")
    exit(1)
}

if !absSourceDir.hasSuffix("/") {
    absSourceDir += "/"
}

if !absDestinationSpace.hasSuffix("/") {
    absDestinationSpace += "/"
}

var fileManager = FileManager.default
var fileEnumerator = fileManager.enumerator(atPath: absSourceDir)

while let srcRelPath = fileEnumerator?.nextObject() as? String {
    let srcRelPathAsURL = URL(fileURLWithPath: srcRelPath)
    let srcFile = FileBean(fileManager: fileManager,
        absPath: absSourceDir + srcRelPath)
    
    if srcFile.fileType != "NSFileTypeDirectory" && !srcFile.fileName.hasPrefix(".") {
        var destination = FileDestination(space: absDestinationSpace,
            dates: srcFile.dates,
            originalFileName: srcRelPathAsURL.lastPathComponent)
        
        var fileMover = FileMover(srcFile: srcFile,
            destination: destination,
            fileManager: fileManager)
        
        fileMover.moveFileToDestination()
    }
}
