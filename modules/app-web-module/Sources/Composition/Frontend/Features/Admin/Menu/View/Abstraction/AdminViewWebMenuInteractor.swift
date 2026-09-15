import FeatherAdmin
import Foundation
import OpenAPIRuntime

protocol AdminViewWebMenuInteractor: Sendable {

    func execute(
        entity: AdminViewWebMenuModel
    ) async throws -> WebMenuDetailsModel
}
