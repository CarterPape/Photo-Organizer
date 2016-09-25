//
//  FileMover.swift
//  Photo Organizer
//
//  Created by Carter Pape on 7/15/15.
//  Copyright (c) 2015 Carter Pape. All rights reserved.
//

import Foundation

class FileMover {
    fileprivate let srcFile: FileBean
    fileprivate var destination: FileDestination
    fileprivate var fileManager: FileManager
    
    init(srcFile: FileBean, destination: FileDestination, fileManager: FileManager) {
        self.srcFile = srcFile
        self.destination = destination
        self.fileManager = fileManager
    }
    
    func moveFileToDestination() {
        let fileExistsAtNonNumberedPath = fileManager.fileExists(atPath: destination.nonNumberedPath)
        let fileExistsAtFirstNumberedPath = fileManager.fileExists(atPath: destination.firstNumberedPath)
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
    
    fileprivate func moveFileToNumberedDestination() {
        while fileManager.fileExists(atPath: destination.numberedPath) {
            destination.increaseFileNumber()
        }
        move(from: srcFile.path, to: destination.numberedPath)
    }
    
    fileprivate func moveExistingNonNumberedFile() {
        var existingFile = FileBean(fileManager: fileManager, absPath: destination.nonNumberedPath)
        move(from: existingFile.path, to: destination.firstNumberedPath)
    }
    
    fileprivate func move(#from: String, _ to: String) {
        var error: NSError?
        fileManager.moveItemAtPath(from, toPath: to, error: &error)
        println(error == nil ? "Moved \(from) to \(to)" : error!)
    }
}
