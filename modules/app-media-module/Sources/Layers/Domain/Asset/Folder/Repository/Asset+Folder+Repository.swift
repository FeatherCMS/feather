public import FeatherDomain
public import MediaModule

extension Asset.Folder.Repository {
    public protocol Interface: FeatherDomain.Repository {
        func insert(
            _ model: Asset.Folder.Model.New
        ) async throws -> Asset.Folder.Model
        func update(
            _ model: Asset.Folder.Model
        ) async throws -> Asset.Folder.Model
        func find(
            id: String
        ) async throws -> Asset.Folder.Model?
        func find(
            slugPath: String
        ) async throws -> Asset.Folder.Model?
        func list(
            parentId: String?
        ) async throws -> [Asset.Folder.Model]
        func listDescendants(
            slugPath: String
        ) async throws -> [Asset.Folder.Model]
        func delete(ids: [String]) async throws -> [String]
    }
}
