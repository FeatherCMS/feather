import FeatherAdmin
import Foundation
import OpenAPIRuntime

protocol AdminGetWebMenuItemInteractor: Sendable {

    func execute(
        entity: AdminGetWebMenuItemModel
    ) async throws -> WebMenuItemDetailsModel
}
