import FeatherWebAdmin
import Hummingbird
import OpenAPIRuntime

protocol AdminListWebPageRepository: Sendable {

    func listWebPages(
        page: Int,
        search: String?
    ) async throws -> AdminListWebPageModel

}
