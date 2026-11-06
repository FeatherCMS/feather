public import ContactDomain
public import ContactModule
public import FeatherApplication

public import struct Foundation.Date

extension Submission.Edit {
    public struct Output: DTO {
        public let id: String
        public let formId: String
        public let valuesJSON: String
        public let itemsSnapshotJSON: String
        public let metadataJSON: String?
        public let status: Submission.Model.Status
        public let createdAt: Date
        public let updatedAt: Date

        init(model: Submission.Model) {
            id = model.id
            formId = model.formId
            valuesJSON = model.valuesJSON
            itemsSnapshotJSON = model.itemsSnapshotJSON
            metadataJSON = model.metadataJSON
            status = model.status
            createdAt = model.createdAt
            updatedAt = model.updatedAt
        }
    }
}
