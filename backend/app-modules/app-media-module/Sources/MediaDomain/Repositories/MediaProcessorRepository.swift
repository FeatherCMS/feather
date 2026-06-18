import Domain

public protocol MediaProcessorRepository: Repository {
    func insert(
        _ model: MediaProcessor.New
    ) async throws -> MediaProcessor
    func update(
        _ model: MediaProcessor
    ) async throws -> MediaProcessor
    func find(
        id: String
    ) async throws -> MediaProcessor?
    func list() async throws -> [MediaProcessor]
    func listActive() async throws -> [MediaProcessor]
    func delete(
        id: String
    ) async throws -> Bool
}
