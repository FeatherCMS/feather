//
//  Log+List+Output.swift
//  app-analytics-module
//
//  Created by Binary Birds on 2026. 06. 18.

import AnalyticsDomain
public import FeatherApplication

extension Log {
    public enum List {}
}

extension Log.List {
    public struct Output: DTO {

        public struct Item: Sendable {
            public let id: String
            public let accountId: String?
            public let source: String
            public let method: String
            public let path: String
            public let responseCode: Int
            public let ip: String?
            public let browserName: String?
            public let createdAt: Double

            package init(
                id: String,
                accountId: String?,
                source: String,
                method: String,
                path: String,
                responseCode: Int,
                ip: String?,
                browserName: String?,
                createdAt: Double
            ) {
                self.id = id
                self.accountId = accountId
                self.source = source
                self.method = method
                self.path = path
                self.responseCode = responseCode
                self.ip = ip
                self.browserName = browserName
                self.createdAt = createdAt
            }
        }

        public let items: [Item]

        public init(items: [Item]) {
            self.items = items
        }
    }
}
