import Hummingbird

protocol AdminListWebPageRepository: Sendable {

    func listWebPages(
        page: Int,
        search: String?
    ) async throws -> AdminListWebPageModel

    func delete(
        id: String
    ) async throws
}
