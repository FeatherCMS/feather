import Testing

import struct Foundation.Date

@testable import ContactDomain

@Suite
struct ContactDomainTestSuite {

    @Test
    func formRejectsEmptyName() {
        #expect(throws: Form.Error.nameTooShort) {
            try Form.create(name: "")
        }
    }

    @Test
    func formCreatePreservesMessagesAndRedirect() throws {
        let form = try Form.create(
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
        let item = try FormField.create(
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
    func submissionPreservesPayloadAndSnapshot() {
        let submission = Submission.create(
            formId: "form-1",
            valuesJSON: #"{"name":"Jane"}"#,
            itemsSnapshotJSON: #"[{"key":"name","type":"text"}]"#
        )
        #expect(submission.valuesJSON.contains("Jane"))
        #expect(submission.itemsSnapshotJSON.contains("name"))
    }
}
