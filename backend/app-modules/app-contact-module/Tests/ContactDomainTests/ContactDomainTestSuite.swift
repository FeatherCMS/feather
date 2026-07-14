import Testing
import struct Foundation.Date
@testable import ContactDomain

@Suite
struct ContactDomainTestSuite {
    @Test
    func formItemRequiresOptionsForChoiceControls() throws {
        let item = try ContactFormItem.create(id: "item-1", formId: "form-1", key: "department", type: .select, label: "Department", allowedValues: [.init(value: "support", label: "Support")], isRequired: true, position: 0)
        #expect(item.allowedValues.count == 1)
    }

    @Test
    func submissionPreservesPayloadAndSnapshot() {
        let submission = ContactFormSubmission.create(id: "submission-1", formId: "form-1", valuesJSON: #"{"name":"Jane"}"#, itemsSnapshotJSON: #"[{"key":"name","type":"text"}]"#)
        #expect(submission.valuesJSON.contains("Jane"))
    }
}
