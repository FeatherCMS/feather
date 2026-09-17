import FeatherDomain

public protocol MediaAssetStorageObjectRepository: Repository {
    func insert(
        _ model: MediaAssetStorageObject.New
    ) async throws -> MediaAssetStorageObject
    func insert(
        _ models: [MediaAssetStorageObject.New]
    ) async throws -> [MediaAssetStorageObject]
    func delete(ids: [String]) async throws -> [String]
}
