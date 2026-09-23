public import FeatherDomain

public protocol MediaAssetNodeFolderRepository: Repository {
    func insert(
        _ model: MediaAssetNodeFolder.New
    ) async throws -> MediaAssetNodeFolder
    func update(
        _ model: MediaAssetNodeFolder
    ) async throws -> MediaAssetNodeFolder
    func find(
        id: String
    ) async throws -> MediaAssetNodeFolder?
    func find(
        slugPath: String
    ) async throws -> MediaAssetNodeFolder?
    func list(
        parentId: String?
    ) async throws -> [MediaAssetNodeFolder]
    func listDescendants(
        slugPath: String
    ) async throws -> [MediaAssetNodeFolder]
    func delete(ids: [String]) async throws -> [String]
}
