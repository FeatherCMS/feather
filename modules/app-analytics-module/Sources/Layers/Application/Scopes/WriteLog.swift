//
//  WriteLog.swift
//  app-analytics-module
//
//  Created by Binary Birds on 2026. 06. 18.

import AnalyticsDomain
import FeatherApplication
import FeatherContracts

public struct WriteLog: Scope {
    public let log: any LogRepository

    public init(log: any LogRepository) {
        self.log = log
    }
}
