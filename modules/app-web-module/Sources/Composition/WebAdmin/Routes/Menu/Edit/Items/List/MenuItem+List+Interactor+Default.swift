import FeatherWebAdmin
import Hummingbird
import OpenAPIRuntime

extension MenuItem.List.Interactor {
    struct Default: Interface {
        let repository: any MenuItem.List.Repository.Interface

        func listMenuItems(
            menuId: String,
            page: Int,
            search: String?
        ) async throws -> MenuItem.List.Model {
            try await repository.listMenuItems(
                menuId: menuId,
                page: page,
                search: search
            )
        }

        func move(
            menuId: String,
            itemId: String,
            beforeItemId: String?
        ) async throws {
            try await repository.move(
                menuId: menuId,
                itemId: itemId,
                beforeItemId: beforeItemId
            )
        }
    }
}
