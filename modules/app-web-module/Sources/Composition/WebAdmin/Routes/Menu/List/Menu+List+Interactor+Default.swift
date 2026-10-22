import FeatherWebAdmin
import Hummingbird
import OpenAPIRuntime
import WebDomain

extension WebDomain.Menu.List.Interactor {
    struct Default: Interface {
        let repository: any WebDomain.Menu.List.Repository.Interface

        func listMenus(
            page: Int,
            search: String?
        ) async throws -> WebDomain.Menu.List.Model {
            try await repository.listMenus(page: page, search: search)
        }

    }
}
