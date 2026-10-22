public import FeatherDomain
public import MediaModule

extension Asset.File {
    public struct StorageIdentity: Sendable {
        public let nodeId: String

        public init(nodeId: String) {
            self.nodeId = nodeId
        }
    }
}

extension Asset.File.Repository {
    public protocol Interface: FeatherDomain.Repository {
        func prepareStorageIdentity() -> Asset.File.StorageIdentity
        func insert(
            _ model: Asset.File.Model.New,
            storageIdentity: Asset.File.StorageIdentity
        ) async throws -> Asset.File.Model
        func update(
            _ model: Asset.File.Model
        ) async throws -> Asset.File.Model
        func updateStatus(
            id: String,
            status: Asset.File.Model.Status
        ) async throws
        func find(
            id: String
        ) async throws -> Asset.File.Model?
        func find(
            slugPath: String
        ) async throws -> Asset.File.Model?
        func list(
            folderIds: [String]
        ) async throws -> [Asset.File.Model]
        func delete(ids: [String]) async throws -> [String]
    }
}
