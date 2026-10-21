//
//  RedirectModule.Rule.List.Output.swift
//  app-redirect-module
//
//  Created by Binary Birds on 2026. 06. 18.

public import FeatherApplication
public import RedirectModule

extension RedirectModule.Rule.List {
    public struct Output: DTO {
        public struct Item: Sendable {
            public let id: String
            public let source: String
            public let destination: String
            public let statusCode: RedirectModule.Rule.StatusCode

            package init(
                id: String,
                source: String,
                destination: String,
                statusCode: RedirectModule.Rule.StatusCode
            ) {
                self.id = id
                self.source = source
                self.destination = destination
                self.statusCode = statusCode
            }
        }

        public let items: [Item]

        public init(items: [Item]) {
            self.items = items
        }
    }
}
