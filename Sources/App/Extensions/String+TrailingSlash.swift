//
//  File.swift
//  
//
//  Created by Julian Gentges on 10.08.20.
//

import Foundation

extension String {
    var withTrailingSlash: String {
        if self.hasSuffix("/") {
            return self
        }
        
        return self + "/"
    }
}
