//
//  MenuItem.swift
//  app-web-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherDomain

import struct Foundation.Date

public struct MenuItem: Model {

    public enum Error: DomainError {
        case labelTooShort
        case labelTooLong
        case urlTooShort
        case urlTooLong
        case priorityOutOfRange
        case notesTooLong
    }

    public struct New: Sendable {
        public let menuId: String
        public let label: String
        public let url: String
        public let priority: Int
        public let isBlank: Bool
        public let permission: String
        public let authentication: MenuItemAuthentication
        public let notes: String?
    }

    public let id: String
    public var menuId: String
    public var label: String
    public var url: String
    public var priority: Int
    public var isBlank: Bool
    public var permission: String
    public var authentication: MenuItemAuthentication
    public var notes: String?
    public let createdAt: Date
    public let updatedAt: Date

    package init(
        id: String,
        menuId: String,
        label: String,
        url: String,
        priority: Int,
        isBlank: Bool,
        permission: String,
        authentication: MenuItemAuthentication,
        notes: String?,
        createdAt: Date,
        updatedAt: Date
    ) {
        self.id = id
        self.menuId = menuId
        self.label = label
        self.url = url
        self.priority = priority
        self.isBlank = isBlank
        self.permission = permission
        self.authentication = authentication
        self.notes = notes
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

extension MenuItem {

    private static func validate(
        label: String
    ) throws(Self.Error) {
        guard !label.isEmpty else {
            throw .labelTooShort
        }
        guard label.count < 255 else {
            throw .labelTooLong
        }
    }

    private static func validate(
        url: String
    ) throws(Self.Error) {
        guard !url.isEmpty else {
            throw .urlTooShort
        }
        guard url.count < 2_000 else {
            throw .urlTooLong
        }
    }

    private static func validate(
        priority: Int
    ) throws(Self.Error) {
        guard (-10_000...10_000).contains(priority) else {
            throw .priorityOutOfRange
        }
    }

    private static func validate(
        notes: String?
    ) throws(Self.Error) {
        guard let notes else {
            return
        }
        guard notes.count < 255 else {
            throw .notesTooLong
        }
    }

    public static func create(
        menuId: String,
        label: String,
        url: String,
        priority: Int,
        isBlank: Bool,
        permission: String,
        authentication: MenuItemAuthentication = .any,
        notes: String?
    ) throws(Self.Error) -> Self.New {
        try validate(label: label)
        try validate(url: url)
        try validate(priority: priority)
        try validate(notes: notes)

        return .init(
            menuId: menuId,
            label: label,
            url: url,
            priority: priority,
            isBlank: isBlank,
            permission: permission,
            authentication: authentication,
            notes: notes
        )
    }

    public mutating func update(
        label: String? = nil,
        url: String? = nil,
        priority: Int? = nil,
        isBlank: Bool? = nil,
        permission: String? = nil,
        authentication: MenuItemAuthentication? = nil,
        notes: String? = nil
    ) throws(Self.Error) {
        let newLabel = label ?? self.label
        let newURL = url ?? self.url
        let newPriority = priority ?? self.priority
        let newPermission = permission ?? self.permission
        let newNotes = notes ?? self.notes

        try Self.validate(label: newLabel)
        try Self.validate(url: newURL)
        try Self.validate(priority: newPriority)
        try Self.validate(notes: newNotes)

        self.label = newLabel
        self.url = newURL
        self.priority = newPriority
        self.isBlank = isBlank ?? self.isBlank
        self.permission = newPermission
        self.authentication = authentication ?? self.authentication
        self.notes = newNotes
    }
}
