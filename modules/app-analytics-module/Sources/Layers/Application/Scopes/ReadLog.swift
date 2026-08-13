//
//  ReadLog.swift
//  app-analytics-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherApplication
import FeatherContracts

public struct ReadLog: Scope {
    public let log: any LogQueries

    public init(log: any LogQueries) {
        self.log = log
    }
}
