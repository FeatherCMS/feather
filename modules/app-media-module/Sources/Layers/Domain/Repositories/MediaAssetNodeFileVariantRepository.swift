import FeatherDomain

public protocol MediaAssetNodeFileVariantRepository: Repository {
    func insert(
        _ model: MediaAssetNodeFileVariant.New
    ) async throws -> MediaAssetNodeFileVariant
    func find(
        nodeId: String,
        processorId: String
    ) async throws -> MediaAssetNodeFileVariant?
    func list(
        nodeId: String
    ) async throws -> [MediaAssetNodeFileVariant]
    func deleteAll(
        nodeId: String
    ) async throws
}
