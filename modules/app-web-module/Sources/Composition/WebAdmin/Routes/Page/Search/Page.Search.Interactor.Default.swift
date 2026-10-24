import FeatherWebAdmin
import Hummingbird
import OpenAPIRuntime
import WebModule

extension Page.Search.Interactor {
    struct Default: Interface {
        let repository: any Page.Search.Repository.Interface

        func searchPages(
            page: Int,
            search: String?
        ) async throws -> Page.Search.Model {
            try await repository.searchPages(page: page, search: search)
        }

    }
}
