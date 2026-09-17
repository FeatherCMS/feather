import FeatherDomain

import struct Foundation.Date

public struct MediaAssetNodeFileVariant: Model {
    public struct New: Sendable {
        public let nodeId: String
        public let processorId: String
        public let name: String
        public let storageObjectId: String
        public let objectKey: String
        public let `extension`: String
    }

    public let id: String
    public let nodeId: String
    public let processorId: String
    public let name: String
    public let storageObjectId: String
    public let objectKey: String
    public let `extension`: String
    public let createdAt: Date

    package init(
        id: String,
        nodeId: String,
        processorId: String,
        name: String,
        storageObjectId: String,
        objectKey: String,
        `extension`: String,
        createdAt: Date
    ) {
        self.id = id
        self.nodeId = nodeId
        self.processorId = processorId
        self.name = name
        self.storageObjectId = storageObjectId
        self.objectKey = objectKey
        self.extension = `extension`
        self.createdAt = createdAt
    }

    public static func create(
        nodeId: String,
        processorId: String,
        name: String,
        storageObjectId: String,
        objectKey: String,
        extension ext: String
    ) -> New {
        .init(
            nodeId: nodeId,
            processorId: processorId,
            name: name,
            storageObjectId: storageObjectId,
            objectKey: objectKey,
            extension: ext
        )
    }
}
