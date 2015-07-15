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