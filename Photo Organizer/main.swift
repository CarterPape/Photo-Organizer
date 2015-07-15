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

struct FileBean {
    let path: String
    let fileAttributes: NSDictionary
    let fileName: String
    let fileType: String
    let fileExtension: String
    let creationDate: NSDate
    
    init(fileManager: NSFileManager, absPath: String) {
        self.path = absPath
        self.fileAttributes = fileManager.attributesOfItemAtPath(absPath, error: nil)!
        self.fileName = absPath.lastPathComponent
        self.fileType = fileAttributes["NSFileType"] as! String
        self.fileExtension = fileName.pathExtension
        self.creationDate = fileAttributes["NSFileCreationDate"] as! NSDate
    }
}

class FileDestination {
    private var date: NSDate
    private var dateParts: [String]
    private var dateString: String
    
    private var space: String
    private var immediateDirectory: String
    var destinationDirectory: String {return immediateDirectory}
    private var originalFileNameWithoutExtension: String
    private var fileExtension: String
    private var fileNumber: Int = 1
    
    private var nonNumberedFileNameWithoutExtension: String
    private var numberedFileNameWithoutExtension: String {
        return nonNumberedFileNameWithoutExtension + "-" + String(fileNumber)
    }
    
    var nonNumberedPath: String
    var firstNumberedPath: String
    var numberedPath: String {
        return immediateDirectory
            + nonNumberedFileNameWithoutExtension
            + "-" + String(fileNumber)
            + "." + fileExtension
    }
    
    init(space: String, date: NSDate, originalFileName: String) {
        self.space = space
        self.date = date
        self.dateParts = date.description.componentsSeparatedByCharactersInSet(NSCharacterSet(charactersInString: " :-"))
        self.dateString = "-".join(dateParts[0...2]) + " " + ".".join(dateParts[3...5])
        self.immediateDirectory = dateString != "2001-01-01 00.00.00"
            ? space + "/".join(dateParts[0...2]) + "/"
            : space + "No date/"
        self.originalFileNameWithoutExtension = originalFileName.lastPathComponent.stringByDeletingPathExtension
        self.fileExtension = originalFileName.pathExtension
        self.nonNumberedFileNameWithoutExtension = dateString != "2001-01-01 00.00.00"
            ? dateString
            : originalFileNameWithoutExtension
        self.nonNumberedPath = immediateDirectory + nonNumberedFileNameWithoutExtension + "." + fileExtension
        self.firstNumberedPath = immediateDirectory
            + nonNumberedFileNameWithoutExtension
            + "-1"
            + "." + fileExtension
    }
    
    func increaseFileNumber() {
        fileNumber += 1
    }
}

class FileMover {
    private let srcFile: FileBean
    private var destination: FileDestination
    private var fileManager: NSFileManager
    
    init(srcFile: FileBean, destination: FileDestination, fileManager: NSFileManager) {
        self.srcFile = srcFile
        self.destination = destination
        self.fileManager = fileManager
    }
    
    func moveFileToDestination() {
        let fileExistsAtNonNumberedPath = fileManager.fileExistsAtPath(destination.nonNumberedPath)
        let fileExistsAtFirstNumberedPath = fileManager.fileExistsAtPath(destination.firstNumberedPath)
        if fileExistsAtNonNumberedPath {
            moveExistingNonNumberedFile()
            moveFileToNumberedDestination()
        }
        else if fileExistsAtFirstNumberedPath {
            moveFileToNumberedDestination()
        }
        else {
            fileManager.createDirectoryAtPath(destination.destinationDirectory,
                withIntermediateDirectories: true, attributes: nil, error: nil)
            move(from: srcFile.path, to: destination.nonNumberedPath)
        }
    }
    
    private func moveFileToNumberedDestination() {
        while fileManager.fileExistsAtPath(destination.numberedPath) {
            destination.increaseFileNumber()
        }
        move(from: srcFile.path, to: destination.numberedPath)
    }
    
    private func moveExistingNonNumberedFile() {
        var existingFile = FileBean(fileManager: fileManager, absPath: destination.nonNumberedPath)
        move(from: existingFile.path, to: destination.firstNumberedPath)
    }
    
    private func move(#from: String, to: String) {
        var error: NSError?
        fileManager.moveItemAtPath(from, toPath: to, error: &error)
        println(error == nil ? "Moved \(from) to \(to)" : error!)
    }
}

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