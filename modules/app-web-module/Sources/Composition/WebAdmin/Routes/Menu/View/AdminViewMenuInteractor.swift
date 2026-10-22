import FeatherWebAdmin
import OpenAPIRuntime

protocol AdminViewMenuInteractor: Sendable {

    func execute(
        entity: AdminViewMenuModel
    ) async throws -> MenuDetailsModel
}
