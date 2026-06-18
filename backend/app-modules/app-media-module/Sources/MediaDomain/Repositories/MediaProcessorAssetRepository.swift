import Domain

public protocol MediaProcessorAssetRepository: Repository {
    func insert(
        _ model: MediaProcessorAsset.New
    ) async throws -> MediaProcessorAsset
    func find(
        assetId: String,
        processorId: String
    ) async throws -> MediaProcessorAsset?
    func list(
        assetId: String
    ) async throws -> [MediaProcessorAsset]
    func deleteAll(
        assetId: String
    ) async throws
}
