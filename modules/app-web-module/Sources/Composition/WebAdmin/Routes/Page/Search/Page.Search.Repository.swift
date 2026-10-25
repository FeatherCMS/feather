import FeatherWebAdmin
import Hummingbird
import OpenAPIRuntime
import WebModule

extension Page.Search {
    enum Repository {}
}

extension Page.Search.Repository {
    protocol Interface: Sendable {
        func search(
            page: Int,
            search: String?
        ) async throws -> Page.Search.Model
    }

}
