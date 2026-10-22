public import FeatherDomain
public import MediaModule

extension Asset.File.Variant.Repository {
    public protocol Interface: FeatherDomain.Repository {
        func insert(
            _ model: Asset.File.Variant.Model.New
        ) async throws -> Asset.File.Variant.Model
        func insert(
            _ models: [Asset.File.Variant.Model.New]
        ) async throws
        func find(
            nodeId: String,
            variantId: String
        ) async throws -> Asset.File.Variant.Model?
        func list(
            nodeId: String
        ) async throws -> [Asset.File.Variant.Model]
        func list(
            nodeIds: [String]
        ) async throws -> [Asset.File.Variant.Model]
        func deleteAll(
            nodeId: String
        ) async throws
        func deleteAll(
            nodeIds: [String]
        ) async throws
    }
}
