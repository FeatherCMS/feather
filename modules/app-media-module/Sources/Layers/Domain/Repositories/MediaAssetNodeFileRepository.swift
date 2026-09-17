import FeatherDomain

public struct MediaAssetNodeFileStorageIdentity: Sendable {
    public let nodeId: String

    public init(nodeId: String) {
        self.nodeId = nodeId
    }
}

public protocol MediaAssetNodeFileRepository: Repository {
    func prepareStorageIdentity() -> MediaAssetNodeFileStorageIdentity
    func insert(
        _ model: MediaAssetNodeFile.New,
        storageIdentity: MediaAssetNodeFileStorageIdentity,
        storageObjectId: String
    ) async throws -> MediaAssetNodeFile
    func update(
        _ model: MediaAssetNodeFile
    ) async throws -> MediaAssetNodeFile
    func updateStatus(
        id: String,
        status: MediaAssetNodeFile.Status
    ) async throws
    func find(
        id: String
    ) async throws -> MediaAssetNodeFile?
    func list(
        folderIds: [String]
    ) async throws -> [MediaAssetNodeFile]
    func delete(ids: [String]) async throws -> [String]
}
