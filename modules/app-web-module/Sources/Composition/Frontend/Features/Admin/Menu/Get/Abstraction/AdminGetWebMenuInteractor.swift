import FeatherAdmin
import Foundation
import OpenAPIRuntime

protocol AdminGetWebMenuInteractor: Sendable {

    func execute(
        entity: AdminGetWebMenuModel
    ) async throws -> WebMenuDetailsModel
}
