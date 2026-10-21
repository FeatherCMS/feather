//
//  RuleModelTestSuite.swift
//  app-redirect-module
//
//  Created by Binary Birds on 2026. 06. 18.

import RedirectModule
import Testing

import FeatherDomain
import struct Foundation.Date

@testable import RedirectDomain

@Suite
struct RuleModelTestSuite {

    @Test
    func ruleNewSucceedsWithValidInput() throws {
        let create = try RedirectModule.Rule.Model.create(
            source: "/from",
            destination: "/to",
            statusCode: .movedPermanently,
            notes: "notes"
        )

        #expect(create.source == "/from")
        #expect(create.destination == "/to")
        #expect(create.statusCode == .movedPermanently)
        #expect(create.notes == "notes")
    }

    @Test
    func ruleSourceUsesLeadingSlashAndKeepsTrailingSlashAndRoot() throws {
        let nested = try RedirectModule.Rule.Model.create(
            source: "from/",
            destination: "/to",
            statusCode: .movedPermanently,
            notes: nil
        )
        let root = try RedirectModule.Rule.Model.create(
            source: "/",
            destination: "/home",
            statusCode: .movedPermanently,
            notes: nil
        )

        #expect(nested.source == "/from/")
        #expect(root.source == "/")
    }

    @Test
    func ruleNewThrowsSourceTooShort() throws {
        #expect(throws: RedirectModule.Rule.Model.Error.sourceTooShort) {
            _ = try RedirectModule.Rule.Model.create(
                source: "",
                destination: "/to",
                statusCode: .movedPermanently,
                notes: "notes"
            )
        }
    }

    @Test
    func ruleNewThrowsSourceTooLong() throws {
        #expect(throws: RedirectModule.Rule.Model.Error.sourceTooLong) {
            _ = try RedirectModule.Rule.Model.create(
                source: String(repeating: "a", count: 255),
                destination: "/to",
                statusCode: .movedPermanently,
                notes: "notes"
            )
        }
    }

    @Test
    func ruleNewThrowsDestinationTooShort() throws {
        #expect(throws: RedirectModule.Rule.Model.Error.destinationTooShort) {
            _ = try RedirectModule.Rule.Model.create(
                source: "/from",
                destination: "",
                statusCode: .movedPermanently,
                notes: "notes"
            )
        }
    }

    @Test
    func ruleNewThrowsDestinationTooLong() throws {
        #expect(throws: RedirectModule.Rule.Model.Error.destinationTooLong) {
            _ = try RedirectModule.Rule.Model.create(
                source: "/from",
                destination: String(repeating: "a", count: 255),
                statusCode: .movedPermanently,
                notes: "notes"
            )
        }
    }

    @Test
    func ruleNewThrowsNotesTooLong() throws {
        #expect(throws: RedirectModule.Rule.Model.Error.notesTooLong) {
            _ = try RedirectModule.Rule.Model.create(
                source: "/from",
                destination: "/to",
                statusCode: .movedPermanently,
                notes: String(repeating: "a", count: 255)
            )
        }
    }

    @Test
    func ruleUpdateSucceedsWithProvidedValues() throws {
        var model = RedirectModule.Rule.Model(
            id: "rule-1",
            source: "/from-a",
            destination: "/to-a",
            statusCode: .movedPermanently,
            notes: "notes-a",
            createdAt: .distantPast,
            updatedAt: .distantFuture
        )

        try model.update(
            source: .set("/from-b"),
            destination: .set("/to-b"),
            statusCode: .set(.permanentRedirect),
            notes: .set("notes-b")
        )

        #expect(model.source == "/from-b")
        #expect(model.destination == "/to-b")
        #expect(model.statusCode == .permanentRedirect)
        #expect(model.notes == "notes-b")
    }

    @Test
    func ruleUpdateNormalizesSourceWithoutRemovingTrailingSlash() throws {
        var model = RedirectModule.Rule.Model(
            id: "rule-1",
            source: "/from",
            destination: "/to",
            statusCode: .movedPermanently,
            notes: nil,
            createdAt: .distantPast,
            updatedAt: .distantFuture
        )

        try model.update(source: .set("to/"))

        #expect(model.source == "/to/")
    }

    @Test
    func ruleUpdateKeepsValuesWhenArgumentsAreNil() throws {
        var model = RedirectModule.Rule.Model(
            id: "rule-1",
            source: "/from-a",
            destination: "/to-a",
            statusCode: .found,
            notes: "notes-a",
            createdAt: .distantPast,
            updatedAt: .distantFuture
        )

        try model.update()

        #expect(model.source == "/from-a")
        #expect(model.destination == "/to-a")
        #expect(model.statusCode == .found)
        #expect(model.notes == "notes-a")
    }

    @Test
    func ruleUpdateThrowsSourceTooShort() throws {
        var model = RedirectModule.Rule.Model(
            id: "rule-1",
            source: "/from-a",
            destination: "/to-a",
            statusCode: .movedPermanently,
            notes: "notes-a",
            createdAt: .distantPast,
            updatedAt: .distantFuture
        )

        #expect(throws: RedirectModule.Rule.Model.Error.sourceTooShort) {
            try model.update(source: .set(""))
        }
    }

    @Test
    func ruleUpdateThrowsDestinationTooLong() throws {
        var model = RedirectModule.Rule.Model(
            id: "rule-1",
            source: "/from-a",
            destination: "/to-a",
            statusCode: .movedPermanently,
            notes: "notes-a",
            createdAt: .distantPast,
            updatedAt: .distantFuture
        )

        #expect(throws: RedirectModule.Rule.Model.Error.destinationTooLong) {
            try model.update(
                destination: .set(String(repeating: "a", count: 255))
            )
        }
    }

    @Test
    func ruleUpdateThrowsNotesTooLong() throws {
        var model = RedirectModule.Rule.Model(
            id: "rule-1",
            source: "/from-a",
            destination: "/to-a",
            statusCode: .movedPermanently,
            notes: "notes-a",
            createdAt: .distantPast,
            updatedAt: .distantFuture
        )

        #expect(throws: RedirectModule.Rule.Model.Error.notesTooLong) {
            try model.update(
                notes: .set(String(repeating: "a", count: 255))
            )
        }
    }
}
