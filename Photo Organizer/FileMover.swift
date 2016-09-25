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
            do {
                try fileManager.createDirectory(atPath:destination.destinationDirectory,
                                                withIntermediateDirectories: true, attributes: nil)
                move(from: srcFile.path, to: destination.nonNumberedPath)
            } catch {
                print("Couldn't create directory \(destination.destinationDirectory)")
            }
        }
    }
    
    fileprivate func moveFileToNumberedDestination() {
        while fileManager.fileExists(atPath: destination.numberedPath) {
            destination.increaseFileNumber()
        }
        move(from: srcFile.path, to: destination.numberedPath)
    }
    
    fileprivate func moveExistingNonNumberedFile() {
        let existingFile = FileBean(fileManager: fileManager, absPath: destination.nonNumberedPath)
        move(from: existingFile.path, to: destination.firstNumberedPath)
    }
    
    fileprivate func move(from: String, to: String) {
        do {
            try fileManager.moveItem(atPath: from, toPath: to)
            print("Moved \(from) to \(to)")
        } catch {
            print("Error while moving \(from) to \(to)")
        }
    }
}
