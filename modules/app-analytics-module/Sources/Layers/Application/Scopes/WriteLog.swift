//
//  WriteLog.swift
//  app-analytics-module
//
//  Created by Binary Birds on 2026. 06. 18.

public import AnalyticsDomain
public import AnalyticsModule
public import FeatherModuleKit

public struct WriteLog: Scope {
    public let log: any Log.Repository.Interface

    public init(log: any Log.Repository.Interface) {
        self.log = log
    }
}
