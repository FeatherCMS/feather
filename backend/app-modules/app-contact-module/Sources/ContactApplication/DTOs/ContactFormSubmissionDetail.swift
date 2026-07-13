import Application
import ContactDomain
import struct Foundation.Date

public struct ContactFormSubmissionDetail: DTO {
    public let id: String
    public let formId: String
    public let valuesJSON: String
    public let itemsSnapshotJSON: String
    public let metadataJSON: String?
    public let status: ContactFormSubmission.Status
    public let submittedAt: Date
    public let createdAt: Date
    public let updatedAt: Date

    package init(
        id: String,
        formId: String,
        valuesJSON: String,
        itemsSnapshotJSON: String,
        metadataJSON: String?,
        status: ContactFormSubmission.Status,
        submittedAt: Date,
        createdAt: Date,
        updatedAt: Date
    ) {
        self.id = id
        self.formId = formId
        self.valuesJSON = valuesJSON
        self.itemsSnapshotJSON = itemsSnapshotJSON
        self.metadataJSON = metadataJSON
        self.status = status
        self.submittedAt = submittedAt
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
