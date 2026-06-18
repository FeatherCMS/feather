//
//  File.swift
//  backend
//
//  Created by Tibor Bödecs on 2026. 04. 26..
//

import Application
import struct Foundation.Date

public struct DefaultClock: Clock {

    public init() {

    }

    public func now() -> Double {
        Date().timeIntervalSince1970
    }
}
