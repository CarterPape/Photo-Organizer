//
//  FileDestination.swift
//  Photo Organizer
//
//  Created by Carter Pape on 7/15/15.
//  Copyright (c) 2015 Carter Pape. All rights reserved.
//

import Foundation

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