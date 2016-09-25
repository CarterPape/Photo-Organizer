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
    let fileAttributes: [FileAttributeKey: Any]
    let fileName: String
    let fileType: String
    let fileExtension: String
    var dates: [Date]
    
    init(fileManager: FileManager, absPath: String) {
        let absPathAsURL = URL(fileURLWithPath: absPath)
        self.path = absPath
        self.fileAttributes = try! fileManager.attributesOfItem(atPath: absPath)
        self.fileName = absPathAsURL.lastPathComponent
        self.fileType = fileAttributes[FileAttributeKey.type] as! String
        self.fileExtension = URL(fileURLWithPath: fileName).pathExtension
        self.dates = [Date]()
        if let creationDate = fileAttributes[FileAttributeKey.creationDate] as? Date {
            self.dates.append(creationDate)
        }
        if let modificationDate = fileAttributes[FileAttributeKey.modificationDate] as? Date {
            self.dates.append(modificationDate)
        }
        if fileName.characters.count >= 19 {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH.mm.ss"
            let index: String.Index = fileName.index(fileName.startIndex, offsetBy: dateFormatter.dateFormat.characters.count + 1)
            let dateString = fileName.substring(to: index)
            if let dateFromName = dateFormatter.date(from: dateString) {
                self.dates.append(dateFromName)
            }
        }
        if self.dates.count == 0 {
            print("No date info for '\(absPath)'")
            exit(EXIT_FAILURE)
        }
    }
}
