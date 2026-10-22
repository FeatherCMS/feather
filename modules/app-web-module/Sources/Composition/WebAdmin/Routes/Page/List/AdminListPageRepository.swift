import FeatherWebAdmin
import Hummingbird
import OpenAPIRuntime

protocol AdminListPageRepository: Sendable {

    func listPages(
        page: Int,
        search: String?
    ) async throws -> AdminListPageModel

}
