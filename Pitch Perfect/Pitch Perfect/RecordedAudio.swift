//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Mac on 3/12/15.
//  Copyright (c) 2015 att. All rights reserved.
//
//  Reference information obtained from developer.apple.com
//

import Foundation

class RecordedAudio: NSObject{
    
    var filePathUrl: NSURL
    var title: String

    init(filePathUrl: NSURL, title: String) {
        self.filePathUrl = filePathUrl
        self.title = title
    }
    
}