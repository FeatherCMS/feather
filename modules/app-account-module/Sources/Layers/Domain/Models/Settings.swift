//
//  Settings.swift
//  app-account-module
//
//  Created by Binary Birds on 2026. 07. 16.

import FeatherDomain
import Foundation

public struct Settings: Model {

    public enum Error: DomainError {
        case invalidUserId
        case invalidLanguage
        case invalidTimezone
        case invalidPageSize
    }

    public struct New: Sendable {
        public let userId: String
        public let language: String
        public let timezone: String
        public let pageSize: Int
    }

    public static let defaultLanguage = "en"
    public static let defaultTimezone = Foundation.TimeZone.current.identifier
    public static let defaultPageSize = 20
    public static let allowedPageSizes: Set<Int> = [10, 20, 50, 100]

    public let userId: String
    public var language: String
    public var timezone: String
    public var pageSize: Int
    public let createdAt: Date
    public let updatedAt: Date

    package init(
        userId: String,
        language: String,
        timezone: String,
        pageSize: Int,
        createdAt: Date,
        updatedAt: Date
    ) {
        self.userId = userId
        self.language = language
        self.timezone = timezone
        self.pageSize = pageSize
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

extension Settings {

    private static func validate(
        userId: String
    ) throws(Self.Error) {
        guard !userId.isEmpty else {
            throw .invalidUserId
        }
    }

    private static func validate(
        language: String
    ) throws(Self.Error) {
        guard !language.isEmpty, language.count < 255 else {
            throw .invalidLanguage
        }
    }

    private static func validate(
        timezone: String
    ) throws(Self.Error) {
        guard
            !timezone.isEmpty,
            timezone.count < 255,
            Foundation.TimeZone(identifier: timezone) != nil
        else {
            throw .invalidTimezone
        }
    }

    private static func validate(
        pageSize: Int
    ) throws(Self.Error) {
        guard allowedPageSizes.contains(pageSize) else {
            throw .invalidPageSize
        }
    }

    public static func create(
        userId: String,
        language: String = Self.defaultLanguage,
        timezone: String = Self.defaultTimezone,
        pageSize: Int = Self.defaultPageSize
    ) throws(Self.Error) -> Self.New {
        try validate(userId: userId)
        try validate(language: language)
        try validate(timezone: timezone)
        try validate(pageSize: pageSize)

        return .init(
            userId: userId,
            language: language,
            timezone: timezone,
            pageSize: pageSize
        )
    }

    public mutating func update(
        language: String,
        timezone: String,
        pageSize: Int
    ) throws(Self.Error) {
        try Self.validate(userId: userId)
        try Self.validate(language: language)
        try Self.validate(timezone: timezone)
        try Self.validate(pageSize: pageSize)

        self.language = language
        self.timezone = timezone
        self.pageSize = pageSize
    }
}
