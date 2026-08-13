import FeatherAdmin
import Foundation
import OpenAPIRuntime

protocol AdminEditWebMenuRepository: Sendable {

    func load(
        id: String
    ) async throws -> WebMenuDetailsModel

    func update(
        id: String,
        input: WebMenuFormInput
    ) async throws
}
