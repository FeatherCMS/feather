import ContactModule
import Testing

import struct Foundation.Date

@testable import ContactDomain

@Suite
struct ContactDomainTests {

    @Test
    func formRejectsEmptyName() {
        #expect(throws: Form.Model.Error.nameTooShort) {
            try Form.Model.create(key: "contact", name: "")
        }
    }

    @Test
    func formCreatePreservesMessagesAndRedirect() throws {
        let form = try Form.Model.create(
            key: "contact",
            name: "Contact",
            successMessage: "Thanks",
            failureMessage: "Try again",
            redirectUrl: "/done"
        )

        #expect(form.successMessage == "Thanks")
        #expect(form.failureMessage == "Try again")
        #expect(form.redirectUrl == "/done")
    }

    @Test
    func formItemRequiresOptionsForChoiceControls() throws {
        let item = try FormField.Model.create(
            formId: "form-1",
            key: "department",
            type: .select,
            label: "Department",
            allowedValues: [.init(value: "support", label: "Support")],
            isRequired: true,
            position: 0
        )
        #expect(item.allowedValues.count == 1)
    }

    @Test
    func hiddenFieldCanBeCreatedWithoutAllowedValues() throws {
        let field = try FormField.Model.create(
            formId: "form-1",
            key: "patient",
            type: .hidden,
            label: "Patient inquiry marker",
            isRequired: true
        )

        #expect(field.type == .hidden)
        #expect(field.allowedValues.isEmpty)
        #expect(field.isRequired)
    }

    @Test
    func formFieldUpdateLeavesUnchangedFieldsUntouched() throws {
        let date = Date(timeIntervalSince1970: 0)
        var field = FormField.Model(
            id: "field-1",
            formId: "form-1",
            key: "name",
            type: .text,
            label: "Name",
            allowedValues: [],
            isRequired: false,
            position: 1,
            createdAt: date,
            updatedAt: date
        )

        try field.update(isRequired: .set(true))

        #expect(field.key == "name")
        #expect(field.label == "Name")
        #expect(field.isRequired)
        #expect(field.position == 1)
    }

    @Test
    func submissionPreservesPayloadAndSnapshot() {
        let submission = Submission.Model.create(
            formId: "form-1",
            valuesJSON: #"{"name":"Jane"}"#,
            itemsSnapshotJSON: #"[{"key":"name","type":"text"}]"#
        )
        #expect(submission.valuesJSON.contains("Jane"))
        #expect(submission.itemsSnapshotJSON.contains("name"))
    }
}
