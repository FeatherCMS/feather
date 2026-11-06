public import FeatherDomain
public import MediaModule

extension StorageObject {
    public enum Repository {
        public protocol Interface: FeatherDomain.Repository {
            func insert(
                _ model: Model.New
            ) async throws -> Model
            func insert(
                _ models: [Model.New]
            ) async throws -> [Model]
            func find(storageObjectId: String) async throws
                -> Model?
            func list(assetNodeFileIds: [String]) async throws
                -> [Model]
        }
    }
}
