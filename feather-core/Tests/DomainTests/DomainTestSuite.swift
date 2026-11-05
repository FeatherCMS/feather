//
//  DomainTestSuite.swift
//  feather-core
//
//  Created by Binary Birds on 2026. 06. 18.

import Testing

@testable import FeatherDomain

@Suite
struct DomainTestSuite {

    private enum MissingValueError: Error {
        case missing
    }

    @Test
    func fieldChangeAppliesSetAndUnchangedValues() {
        #expect(
            FieldChange<String>.unchanged.apply(to: "current") == "current"
        )
        #expect(
            FieldChange<String>.set("updated").apply(to: "current")
                == "updated"
        )
    }

    @Test
    func optionalFieldChangeAppliesSetClearAndUnchangedValues() {
        #expect(
            OptionalFieldChange<String>.unchanged.apply(to: "current")
                == "current"
        )
        #expect(OptionalFieldChange<String>.unchanged.apply(to: nil) == nil)
        #expect(
            OptionalFieldChange<String>.set("updated").apply(to: "current")
                == "updated"
        )
        #expect(
            OptionalFieldChange<String>.clear.apply(to: "current") == nil
        )
    }

    @Test
    func fieldChangeInitializerRespectsInclusionAndMissingValue() throws {
        let unchanged = try FieldChange<String>(
            value: nil,
            shouldApply: false,
            onMissing: { MissingValueError.missing }
        )
        #expect(unchanged.apply(to: "current") == "current")

        let set = try FieldChange<String>(
            value: "updated",
            shouldApply: true,
            onMissing: { MissingValueError.missing }
        )
        #expect(set.apply(to: "current") == "updated")

        #expect(throws: MissingValueError.self) {
            try FieldChange<String>(
                value: nil,
                shouldApply: true,
                onMissing: { MissingValueError.missing }
            )
        }
    }

    @Test
    func optionalFieldChangeInitializerRespectsInclusion() {
        let unchanged = OptionalFieldChange<String>(
            value: "ignored",
            shouldApply: false
        )
        #expect(unchanged.apply(to: "current") == "current")

        let set = OptionalFieldChange<String>(
            value: "updated",
            shouldApply: true
        )
        #expect(set.apply(to: "current") == "updated")

        let clear = OptionalFieldChange<String>(value: nil, shouldApply: true)
        #expect(clear.apply(to: "current") == nil)
    }
}
