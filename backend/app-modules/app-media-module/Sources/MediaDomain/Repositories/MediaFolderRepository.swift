import Domain

public protocol MediaFolderRepository: Repository {
    func insert(
        _ model: MediaFolder.New
    ) async throws -> MediaFolder
    func update(
        _ model: MediaFolder
    ) async throws -> MediaFolder
    func find(
        id: String
    ) async throws -> MediaFolder?
    func find(
        path: String
    ) async throws -> MediaFolder?
    func list(
        parentId: String?
    ) async throws -> [MediaFolder]
    func listDescendants(
        path: String
    ) async throws -> [MediaFolder]
    func delete(
        id: String
    ) async throws -> Bool
}
