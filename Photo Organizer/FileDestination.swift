//
//  FileDestination.swift
//  Photo Organizer
//
//  Created by Carter Pape on 7/15/15.
//  Copyright (c) 2015 Carter Pape. All rights reserved.
//

import Foundation

class FileDestination {
    fileprivate var date: Date
    fileprivate var dateParts: [String]
    fileprivate var dateString: String
    
    fileprivate var space: String
    fileprivate var immediateDirectory: String
    var destinationDirectory: String {return immediateDirectory}
    fileprivate var originalFileNameWithoutExtension: String
    fileprivate var fileExtension: String
    fileprivate var fileNumber: Int = 1
    
    fileprivate var nonNumberedFileNameWithoutExtension: String
    fileprivate var numberedFileNameWithoutExtension: String {
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
    
    init(space: String, dates: [Date], originalFileName: String) {
        let originalFileURL = URL(fileURLWithPath: originalFileName)
        self.space = space
        self.date = Date()
        for eachDate in dates {
            self.date = (self.date as NSDate).earlierDate(eachDate)
        }
        self.dateParts = date.description.components(separatedBy: CharacterSet(charactersIn: " :-"))
        self.dateString = dateParts[0...2].joined(separator: "-") + " " + dateParts[3...5].joined(separator: ".")
        self.immediateDirectory = dateString != "2001-01-01 00.00.00"
            ? space + dateParts[0...2].joined(separator: "/") + "/"
            : space + "No date/"
        self.originalFileNameWithoutExtension = originalFileURL.deletingPathExtension().lastPathComponent
        self.fileExtension = originalFileURL.pathExtension
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
