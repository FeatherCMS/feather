import FeatherWebAdmin
import Hummingbird
import OpenAPIRuntime

protocol AdminListPageInteractor: Sendable {

    func listPages(
        page: Int,
        search: String?
    ) async throws -> AdminListPageModel

}
