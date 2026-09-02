import FeatherAdmin
import Hummingbird
import OpenAPIRuntime

protocol AdminListWebPageInteractor: Sendable {

    func listWebPages(
        page: Int,
        search: String?
    ) async throws -> AdminListWebPageModel

    func remove(
        ids: [String]
    ) async throws
}
