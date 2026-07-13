import Domain
import struct Foundation.Date

public struct ContactFormSubmission: Model {

    public enum Status: String, Sendable, CaseIterable {
        case received
        case processed
        case spam
        case failed
    }

    public struct New: Sendable {
        public let id: String
        public let formId: String
        public let valuesJSON: String
        public let itemsSnapshotJSON: String
        public let metadataJSON: String?
        public let status: Status
        public let submittedAt: Date
    }

    public let id: String
    public let formId: String
    public let valuesJSON: String
    public let itemsSnapshotJSON: String
    public let metadataJSON: String?
    public var status: Status
    public let submittedAt: Date
    public let createdAt: Date
    public let updatedAt: Date

    package init(
        id: String,
        formId: String,
        valuesJSON: String,
        itemsSnapshotJSON: String,
        metadataJSON: String?,
        status: Status,
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

public extension ContactFormSubmission {
    static func create(
        id: String,
        formId: String,
        valuesJSON: String,
        itemsSnapshotJSON: String,
        metadataJSON: String? = nil,
        submittedAt: Date
    ) -> Self.New {
        .init(
            id: id,
            formId: formId,
            valuesJSON: valuesJSON,
            itemsSnapshotJSON: itemsSnapshotJSON,
            metadataJSON: metadataJSON,
            status: .received,
            submittedAt: submittedAt
        )
    }
}
