public import FeatherDomain
public import MediaModule

extension StorageObject.Repository {
    public protocol Interface: FeatherDomain.Repository {
        func insert(
            _ model: StorageObject.Model.New
        ) async throws -> StorageObject.Model
        func insert(
            _ models: [StorageObject.Model.New]
        ) async throws -> [StorageObject.Model]
        func find(storageObjectId: String) async throws
            -> StorageObject.Model?
        func list(assetNodeFileIds: [String]) async throws
            -> [StorageObject.Model]
    }
}
