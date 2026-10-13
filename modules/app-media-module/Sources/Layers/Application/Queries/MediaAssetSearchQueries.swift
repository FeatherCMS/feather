public protocol MediaAssetSearchQueries: Sendable {
    func list(
        query: MediaAssetList.Query
    ) async throws -> MediaAssetSearchList
    func count(
        query: MediaAssetList.Query
    ) async throws -> Int
}
