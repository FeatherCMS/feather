//
//  Permission+Model+Tests.swift
//  app-system-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherDomain
import SystemModule
import Testing

import struct Foundation.Date

@testable import SystemDomain

@Suite
struct PermissionModelTests {

    @Test
    func permissionNewSucceedsWithValidInput() throws {
        let create = try Permission.Model.create(
            key: "perm-1",
            name: "abcd",
            notes: "notes"
        )

        #expect(create.key == "perm-1")
        #expect(create.name == "abcd")
        #expect(create.notes == "notes")
    }

    @Test
    func permissionNewThrowsKeyTooShort() throws {
        #expect(throws: Permission.Model.Error.keyTooShort) {
            _ = try Permission.Model.create(
                key: "",
                name: nil,
                notes: nil
            )
        }
    }

    @Test
    func permissionNewThrowsKeyTooLong() throws {
        #expect(throws: Permission.Model.Error.keyTooLong) {
            _ = try Permission.Model.create(
                key: String(repeating: "a", count: 255),
                name: nil,
                notes: nil
            )
        }
    }

    @Test
    func permissionNewThrowsNameTooShort() throws {
        #expect(throws: Permission.Model.Error.nameTooShort) {
            _ = try Permission.Model.create(
                key: "perm-1",
                name: "abc",
                notes: "notes"
            )
        }
    }

    @Test
    func permissionNewThrowsNameTooLong() throws {
        #expect(throws: Permission.Model.Error.nameTooLong) {
            _ = try Permission.Model.create(
                key: "perm-1",
                name: String(repeating: "a", count: 255),
                notes: "notes"
            )
        }
    }

    @Test
    func permissionNewThrowsNotesTooLong() throws {
        #expect(throws: Permission.Model.Error.notesTooLong) {
            _ = try Permission.Model.create(
                key: "perm-1",
                name: "abcd",
                notes: String(repeating: "a", count: 255)
            )
        }
    }

    @Test
    func permissionUpdateSucceedsWithProvidedValues() throws {
        var model = Permission.Model(
            id: "perm-1",
            key: "perm-key",
            name: "name-a",
            notes: "notes-a"
        )

        try model.update(
            key: .set("perm-key-b"),
            name: .set("name-b"),
            notes: .set("notes-b")
        )

        #expect(model.key == "perm-key-b")
        #expect(model.name == "name-b")
        #expect(model.notes == "notes-b")
    }

    @Test
    func permissionUpdateKeepsValuesWhenArgumentsAreNil() throws {
        var model = Permission.Model(
            id: "perm-1",
            key: "perm-key",
            name: "name-a",
            notes: "notes-a"
        )

        try model.update()

        #expect(model.name == "name-a")
        #expect(model.notes == "notes-a")
    }

    @Test
    func permissionUpdateCanClearOptionalValues() throws {
        var model = Permission.Model(
            id: "perm-1",
            key: "perm-key",
            name: "name-a",
            notes: "notes-a"
        )

        try model.update(name: .clear, notes: .clear)

        #expect(model.name == nil)
        #expect(model.notes == nil)
    }

    @Test
    func permissionUpdateThrowsKeyTooShort() throws {
        var model = Permission.Model(
            id: "perm-1",
            key: "perm-key",
            name: "name-a",
            notes: "notes-a"
        )

        #expect(throws: Permission.Model.Error.keyTooShort) {
            try model.update(key: .set(""))
        }
    }

    @Test
    func permissionUpdateThrowsKeyTooLong() throws {
        var model = Permission.Model(
            id: "perm-1",
            key: "perm-key",
            name: "name-a",
            notes: "notes-a"
        )

        #expect(throws: Permission.Model.Error.keyTooLong) {
            try model.update(key: .set(String(repeating: "a", count: 255)))
        }
    }

    @Test
    func permissionUpdateThrowsNameTooShort() throws {
        var model = Permission.Model(
            id: "perm-1",
            key: "perm-key",
            name: "name-a",
            notes: "notes-a"
        )

        #expect(throws: Permission.Model.Error.nameTooShort) {
            try model.update(name: .set("abc"))
        }
    }

    @Test
    func permissionUpdateThrowsNameTooLong() throws {
        var model = Permission.Model(
            id: "perm-1",
            key: "perm-key",
            name: "name-a",
            notes: "notes-a"
        )

        #expect(throws: Permission.Model.Error.nameTooLong) {
            try model.update(name: .set(String(repeating: "a", count: 255)))
        }
    }

    @Test
    func permissionUpdateThrowsNotesTooLong() throws {
        var model = Permission.Model(
            id: "perm-1",
            key: "perm-key",
            name: "name-a",
            notes: "notes-a"
        )

        #expect(throws: Permission.Model.Error.notesTooLong) {
            try model.update(notes: .set(String(repeating: "a", count: 255)))
        }
    }
}
