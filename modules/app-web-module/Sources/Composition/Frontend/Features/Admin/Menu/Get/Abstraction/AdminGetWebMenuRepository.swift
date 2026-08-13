import FeatherAdmin
import Foundation
import OpenAPIRuntime

protocol AdminGetWebMenuRepository: Sendable {

    func get(
        id: String
    ) async throws -> WebMenuDetailsModel
}
