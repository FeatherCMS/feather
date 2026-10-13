public import FeatherDomain

public protocol MediaAssetStorageObjectRepository: Repository {
    func insert(
        _ model: MediaAssetStorageObject.New
    ) async throws -> MediaAssetStorageObject
    func insert(
        _ models: [MediaAssetStorageObject.New]
    ) async throws -> [MediaAssetStorageObject]
    func find(storageObjectId: String) async throws
        -> MediaAssetStorageObject?
    func list(assetNodeFileIds: [String]) async throws
        -> [MediaAssetStorageObject]
}
