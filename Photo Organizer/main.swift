//
//  main.swift
//  Photo Organizer
//
//  Created by Carter Pape on 7/11/15.
//  Copyright (c) 2015 Carter Pape. All rights reserved.
//

import Foundation

let absSourceDir = Process.arguments[1]
let absDestinationSpace = Process.arguments[2]

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