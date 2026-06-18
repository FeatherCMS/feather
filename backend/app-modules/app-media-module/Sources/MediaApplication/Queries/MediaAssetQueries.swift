public protocol MediaAssetQueries: Sendable {
    func find(
        id: String
    ) async throws -> MediaAssetDetail
    func list(
        query: MediaAssetList.Query
    ) async throws -> MediaAssetList
    func count(
        query: MediaAssetList.Query
    ) async throws -> Int
    func findByStorageKey(
        _ storageKey: String
    ) async throws -> MediaAssetDetail?
}
