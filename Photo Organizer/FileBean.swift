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
    var dates: [Date]
    
    init(fileManager: FileManager, absPath: String) {
        self.path = absPath
        self.fileAttributes = fileManager.attributesOfItemAtPath(absPath, error: nil)!
        self.fileName = absPath.lastPathComponent
        self.fileType = fileAttributes["NSFileType"] as! String
        self.fileExtension = fileName.pathExtension
        self.dates = [Date]()
        if let creationDate = fileAttributes["NSFileCreationDate"] as? Date {
            self.dates.append(creationDate)
        }
        if let modificationDate = fileAttributes["NSFileModificationDate"] as? Date {
            self.dates.append(modificationDate)
        }
        if count(fileName) >= 19 {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH.mm.ss"
            let index: String.Index = advance(fileName.startIndex, count(dateFormatter.dateFormat) + 1)
            let dateString = fileName.substring(to: index)
            if let dateFromName = dateFormatter.date(from: dateString) {
                self.dates.append(dateFromName)
            }
        }
        if self.dates.count == 0 {
            println("No date info for '\(absPath)'")
            exit(EXIT_FAILURE)
        }
    }
}
