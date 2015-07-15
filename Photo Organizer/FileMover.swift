//
//  FileMover.swift
//  Photo Organizer
//
//  Created by Carter Pape on 7/15/15.
//  Copyright (c) 2015 Carter Pape. All rights reserved.
//

import Foundation

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