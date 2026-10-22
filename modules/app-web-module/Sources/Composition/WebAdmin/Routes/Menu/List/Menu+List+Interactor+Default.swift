import FeatherWebAdmin
import Hummingbird
import OpenAPIRuntime
import WebDomain

extension Menu.List.Interactor {
    struct Default: Interface {
        let repository: any Menu.List.Repository.Interface

        func listWebMenus(
            page: Int,
            search: String?
        ) async throws -> Menu.List.Model {
            try await repository.listWebMenus(page: page, search: search)
        }

    }
}
