//
//  Rule.Resolve.Output.swift
//  app-redirect-module
//
//  Created by Binary Birds on 2026. 06. 18.

public import FeatherApplication
public import RedirectModule

extension Rule.Resolve {
    public struct Output: DTO {
        public let source: String
        public let destination: String
        public let statusCode: Rule.StatusCode

        public init(
            source: String,
            destination: String,
            statusCode: Rule.StatusCode
        ) {
            self.source = source
            self.destination = destination
            self.statusCode = statusCode
        }
    }
}
