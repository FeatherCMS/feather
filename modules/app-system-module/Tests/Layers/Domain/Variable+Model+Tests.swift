//
//  Variable+Model+Tests.swift
//  app-system-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherDomain
import SystemModule
import Testing

import struct Foundation.Date

@testable import SystemDomain

@Suite
struct VariableModelTests {

    @Test
    func variableNewSucceedsWithValidInput() throws {
        let create = try Variable.Model.create(
            key: "var-1",
            value: "value",
            name: "abcd",
            notes: "notes"
        )

        #expect(create.key == "var-1")
        #expect(create.name == "abcd")
        #expect(create.value == "value")
        #expect(create.notes == "notes")
    }

    @Test
    func variableNewThrowsKeyTooShort() throws {
        #expect(throws: Variable.Model.Error.keyTooShort) {
            _ = try Variable.Model.create(
                key: "",
                value: "value",
                name: nil,
                notes: nil
            )
        }
    }

    @Test
    func variableNewThrowsKeyTooLong() throws {
        #expect(throws: Variable.Model.Error.keyTooLong) {
            _ = try Variable.Model.create(
                key: String(repeating: "a", count: 255),
                value: "value",
                name: nil,
                notes: nil
            )
        }
    }

    @Test
    func variableNewThrowsNameTooShort() throws {
        #expect(throws: Variable.Model.Error.nameTooShort) {
            _ = try Variable.Model.create(
                key: "var-1",
                value: "value",
                name: "abc",
                notes: "notes"
            )
        }
    }

    @Test
    func variableNewThrowsNameTooLong() throws {
        #expect(throws: Variable.Model.Error.nameTooLong) {
            _ = try Variable.Model.create(
                key: "var-1",
                value: "value",
                name: String(repeating: "a", count: 255),
                notes: "notes"
            )
        }
    }

    @Test
    func variableNewThrowsValueTooLong() throws {
        #expect(throws: Variable.Model.Error.valueTooLong) {
            _ = try Variable.Model.create(
                key: "var-1",
                value: String(repeating: "a", count: 255),
                name: "abcd",
                notes: "notes"
            )
        }
    }

    @Test
    func variableNewThrowsNotesTooLong() throws {
        #expect(throws: Variable.Model.Error.notesTooLong) {
            _ = try Variable.Model.create(
                key: "var-1",
                value: "value",
                name: "abcd",
                notes: String(repeating: "a", count: 255)
            )
        }
    }

    @Test
    func variableUpdateSucceedsWithProvidedValues() throws {
        var model = Variable.Model(
            id: "var-1",
            key: "key-1",
            value: "value-a",
            name: "name-a",
            notes: "notes-a"
        )

        try model.update(
            key: .set("key-b"),
            name: .set("name-b"),
            value: .set("value-b"),
            notes: .set("notes-b")
        )

        #expect(model.key == "key-b")
        #expect(model.name == "name-b")
        #expect(model.value == "value-b")
        #expect(model.notes == "notes-b")
    }

    @Test
    func variableUpdateKeepsValuesWhenArgumentsAreNil() throws {
        var model = Variable.Model(
            id: "var-1",
            key: "key-1",
            value: "value-a",
            name: "name-a",
            notes: "notes-a"
        )

        try model.update()

        #expect(model.name == "name-a")
        #expect(model.value == "value-a")
        #expect(model.notes == "notes-a")
    }

    @Test
    func variableUpdateCanClearOptionalValues() throws {
        var model = Variable.Model(
            id: "var-1",
            key: "key-1",
            value: "value-a",
            name: "name-a",
            notes: "notes-a"
        )

        try model.update(name: .clear, notes: .clear)

        #expect(model.name == nil)
        #expect(model.notes == nil)
    }

    @Test
    func variableUpdateThrowsKeyTooShort() throws {
        var model = Variable.Model(
            id: "var-1",
            key: "key-1",
            value: "value-a",
            name: "name-a",
            notes: "notes-a"
        )

        #expect(throws: Variable.Model.Error.keyTooShort) {
            try model.update(key: .set(""))
        }
    }

    @Test
    func variableUpdateThrowsKeyTooLong() throws {
        var model = Variable.Model(
            id: "var-1",
            key: "key-1",
            value: "value-a",
            name: "name-a",
            notes: "notes-a"
        )

        #expect(throws: Variable.Model.Error.keyTooLong) {
            try model.update(key: .set(String(repeating: "a", count: 255)))
        }
    }

    @Test
    func variableUpdateThrowsNameTooShort() throws {
        var model = Variable.Model(
            id: "var-1",
            key: "key-1",
            value: "value-a",
            name: "name-a",
            notes: "notes-a"
        )

        #expect(throws: Variable.Model.Error.nameTooShort) {
            try model.update(name: .set("abc"))
        }
    }

    @Test
    func variableUpdateThrowsNameTooLong() throws {
        var model = Variable.Model(
            id: "var-1",
            key: "key-1",
            value: "value-a",
            name: "name-a",
            notes: "notes-a"
        )

        #expect(throws: Variable.Model.Error.nameTooLong) {
            try model.update(name: .set(String(repeating: "a", count: 255)))
        }
    }

    @Test
    func variableUpdateThrowsValueTooLong() throws {
        var model = Variable.Model(
            id: "var-1",
            key: "key-1",
            value: "value-a",
            name: "name-a",
            notes: "notes-a"
        )

        #expect(throws: Variable.Model.Error.valueTooLong) {
            try model.update(value: .set(String(repeating: "a", count: 255)))
        }
    }

    @Test
    func variableUpdateThrowsNotesTooLong() throws {
        var model = Variable.Model(
            id: "var-1",
            key: "key-1",
            value: "value-a",
            name: "name-a",
            notes: "notes-a"
        )

        #expect(throws: Variable.Model.Error.notesTooLong) {
            try model.update(notes: .set(String(repeating: "a", count: 255)))
        }
    }
}
