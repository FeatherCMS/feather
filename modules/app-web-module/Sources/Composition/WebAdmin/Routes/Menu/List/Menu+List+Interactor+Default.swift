import FeatherWebAdmin
import Hummingbird
import OpenAPIRuntime
import WebDomain
import WebModule

extension WebModule.Menu.List.Interactor {
    struct Default: Interface {
        let repository: any WebModule.Menu.List.Repository.Interface

        func listMenus(
            page: Int,
            search: String?
        ) async throws -> WebModule.Menu.List.Model {
            try await repository.search(page: page, search: search)
        }

    }
}
