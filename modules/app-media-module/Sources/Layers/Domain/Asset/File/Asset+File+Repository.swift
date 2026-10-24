public import FeatherDomain
public import MediaModule

extension Asset.File {
    public struct StorageIdentity: Sendable {
        public let nodeId: String

        public init(nodeId: String) {
            self.nodeId = nodeId
        }
    }

    public enum Repository {
        public protocol Interface: FeatherDomain.Repository {
            func prepareStorageIdentity() -> StorageIdentity
            func insert(
                _ model: Model.New,
                storageIdentity: StorageIdentity
            ) async throws -> Model
            func update(_ model: Model) async throws -> Model
            func updateStatus(id: String, status: Model.Status) async throws
            func find(id: String) async throws -> Model?
            func find(slugPath: String) async throws -> Model?
            func list(folderIds: [String]) async throws -> [Model]
            func delete(ids: [String]) async throws -> [String]
        }
    }
}
