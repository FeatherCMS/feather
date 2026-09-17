import FeatherDomain

public protocol MediaAssetNodeFileVariantRepository: Repository {
    func insert(
        _ model: MediaAssetNodeFileVariant.New
    ) async throws -> MediaAssetNodeFileVariant
    func insert(
        _ models: [MediaAssetNodeFileVariant.New]
    ) async throws
    func find(
        nodeId: String,
        variantId: String
    ) async throws -> MediaAssetNodeFileVariant?
    func list(
        nodeId: String
    ) async throws -> [MediaAssetNodeFileVariant]
    func list(
        nodeIds: [String]
    ) async throws -> [MediaAssetNodeFileVariant]
    func deleteAll(
        nodeId: String
    ) async throws
    func deleteAll(
        nodeIds: [String]
    ) async throws
}
