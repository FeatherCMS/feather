import ContactDomain
import FeatherApplication
import FeatherContracts

import struct Foundation.Date

public struct SubmissionDetail: DTO {
    public let id: String
    public let formId: String
    public let valuesJSON: String
    public let itemsSnapshotJSON: String
    public let metadataJSON: String?
    public let status: Submission.Status
    public let createdAt: Date
    public let updatedAt: Date

    package init(
        id: String,
        formId: String,
        valuesJSON: String,
        itemsSnapshotJSON: String,
        metadataJSON: String?,
        status: Submission.Status,
        createdAt: Date,
        updatedAt: Date
    ) {
        self.id = id
        self.formId = formId
        self.valuesJSON = valuesJSON
        self.itemsSnapshotJSON = itemsSnapshotJSON
        self.metadataJSON = metadataJSON
        self.status = status
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
