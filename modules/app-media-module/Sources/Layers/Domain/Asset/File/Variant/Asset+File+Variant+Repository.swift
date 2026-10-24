public import FeatherDomain
public import MediaModule

extension Asset.File.Variant {
    public enum Repository {
        public protocol Interface: FeatherDomain.Repository {
            func insert(
                _ model: Model.New
            ) async throws -> Model
            func insert(
                _ models: [Model.New]
            ) async throws
            func find(
                nodeId: String,
                variantId: String
            ) async throws -> Model?
            func list(
                nodeId: String
            ) async throws -> [Model]
            func list(
                nodeIds: [String]
            ) async throws -> [Model]
            func deleteAll(
                nodeId: String
            ) async throws
            func deleteAll(
                nodeIds: [String]
            ) async throws
        }
    }
}
