//
//  Rule+Detail+Output.swift
//  app-redirect-module
//
//  Created by Binary Birds on 2026. 06. 18.

public import FeatherApplication
public import RedirectDomain
public import RedirectModule

public import struct Foundation.Date

extension Rule.Detail {
    public struct Output: DTO {
        public let id: String
        public let source: String
        public let destination: String
        public let statusCode: Rule.Model.StatusCode
        public let notes: String?
        public let createdAt: Date
        public let updatedAt: Date

        package init(
            id: String,
            source: String,
            destination: String,
            statusCode: Rule.Model.StatusCode,
            notes: String?,
            createdAt: Date,
            updatedAt: Date
        ) {
            self.id = id
            self.source = source
            self.destination = destination
            self.statusCode = statusCode
            self.notes = notes
            self.createdAt = createdAt
            self.updatedAt = updatedAt
        }
    }
}
