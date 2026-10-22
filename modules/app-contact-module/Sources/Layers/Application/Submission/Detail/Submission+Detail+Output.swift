public import ContactDomain
public import ContactModule
public import FeatherApplication

public import struct Foundation.Date

extension Submission.Detail {
    public struct Output: DTO {
        public let id: String
        public let formId: String
        public let valuesJSON: String
        public let itemsSnapshotJSON: String
        public let metadataJSON: String?
        public let status: Submission.Model.Status
        public let createdAt: Date
        public let updatedAt: Date

        package init(
            id: String,
            formId: String,
            valuesJSON: String,
            itemsSnapshotJSON: String,
            metadataJSON: String?,
            status: Submission.Model.Status,
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
}

extension Submission.Model {
    var asDetail: Submission.Detail.Output {
        .init(
            id: id,
            formId: formId,
            valuesJSON: valuesJSON,
            itemsSnapshotJSON: itemsSnapshotJSON,
            metadataJSON: metadataJSON,
            status: status,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}
