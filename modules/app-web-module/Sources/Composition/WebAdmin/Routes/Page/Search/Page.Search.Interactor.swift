import FeatherWebAdmin
import Hummingbird
import OpenAPIRuntime
import WebModule

extension Page.Search {
    enum Interactor {}
}

extension Page.Search.Interactor {
    protocol Interface: Sendable {

        func searchPages(
            page: Int,
            search: String?
        ) async throws -> Page.Search.Model
    }
}
