//
//  FileBean.swift
//  Photo Organizer
//
//  Created by Carter Pape on 7/15/15.
//  Copyright (c) 2015 Carter Pape. All rights reserved.
//

import Foundation

struct FileBean {
    let path: String
    let fileAttributes: NSDictionary
    let fileName: String
    let fileType: String
    let fileExtension: String
    var dates: [NSDate]
    
    init(fileManager: NSFileManager, absPath: String) {
        self.path = absPath
        self.fileAttributes = fileManager.attributesOfItemAtPath(absPath, error: nil)!
        self.fileName = absPath.lastPathComponent
        self.fileType = fileAttributes["NSFileType"] as! String
        self.fileExtension = fileName.pathExtension
        self.dates = [NSDate]()
        if let creationDate = fileAttributes["NSFileCreationDate"] as? NSDate {
            self.dates.append(creationDate)
        }
        if let modificationDate = fileAttributes["NSFileModificationDate"] as? NSDate {
            self.dates.append(modificationDate)
        }
        if count(fileName) >= 19 {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH.mm.ss"
            let index: String.Index = advance(fileName.startIndex, count(dateFormatter.dateFormat) + 1)
            let dateString = fileName.substringToIndex(index)
            if let dateFromName = dateFormatter.dateFromString(dateString) {
                self.dates.append(dateFromName)
            }
        }
        if self.dates.count == 0 {
            println("No date info for '\(absPath)'")
            exit(EXIT_FAILURE)
        }
    }
}