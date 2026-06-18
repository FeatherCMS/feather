import Hummingbird

protocol AdminListMediaProcessorInteractor: Sendable {

    func listMediaProcessors(
        page: Int
    ) async throws -> AdminListMediaProcessorModel

    func bulkRemove(
        ids: [String]
    ) async throws
}
