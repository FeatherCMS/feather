import FeatherDomain

import struct Foundation.Date

public struct Submission: Model {

    public enum Status: String, Sendable, CaseIterable {
        case received
        case processed
        case spam
        case failed
    }

    public struct New: Sendable {
        public let formId: String
        public let valuesJSON: String
        public let itemsSnapshotJSON: String
        public let metadataJSON: String?
        public let status: Status
    }

    public let id: String
    public let formId: String
    public let valuesJSON: String
    public let itemsSnapshotJSON: String
    public let metadataJSON: String?
    public var status: Status
    public let createdAt: Date
    public let updatedAt: Date

    package init(
        id: String,
        formId: String,
        valuesJSON: String,
        itemsSnapshotJSON: String,
        metadataJSON: String?,
        status: Status,
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

extension Submission {
    public static func create(
        formId: String,
        valuesJSON: String,
        itemsSnapshotJSON: String,
        metadataJSON: String? = nil,
    ) -> Self.New {
        .init(
            formId: formId,
            valuesJSON: valuesJSON,
            itemsSnapshotJSON: itemsSnapshotJSON,
            metadataJSON: metadataJSON,
            status: .received,
        )
    }
}
