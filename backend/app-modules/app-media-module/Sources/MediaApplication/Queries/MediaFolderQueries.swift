public protocol MediaFolderQueries: Sendable {
    func find(
        id: String
    ) async throws -> MediaFolderDetail
    func list(
        query: MediaFolderList.Query
    ) async throws -> MediaFolderList
}
