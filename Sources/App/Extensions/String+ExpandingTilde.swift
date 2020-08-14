//
//  File.swift
//  
//
//  Created by Julian Gentges on 10.08.20.
//

import Foundation

extension String {
    var expandingTildeInPath: String {
        var path = NSString(string: self).expandingTildeInPath
        
        if self.hasSuffix("/") {
            path += "/"
        }
        return path
    }
}
