import FeatherAdmin
import Foundation
import OpenAPIRuntime

protocol AdminAddWebMenuItemInteractor: Sendable {

    func execute(
        menuId: String,
        input: WebMenuItemFormInput
    ) async throws
}
