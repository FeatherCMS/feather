import Domain

public protocol MediaAssetRepository: Repository {
    func insert(
        _ model: MediaAsset.New
    ) async throws -> MediaAsset
    func update(
        _ model: MediaAsset
    ) async throws -> MediaAsset
    func find(
        id: String
    ) async throws -> MediaAsset?
    func find(
        storageKey: String
    ) async throws -> MediaAsset?
    func list(
        folderIds: [String]
    ) async throws -> [MediaAsset]
    func delete(
        id: String
    ) async throws -> Bool
}
