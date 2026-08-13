import FeatherAdmin
import Foundation
import OpenAPIRuntime

protocol AdminGetWebPageRepository: Sendable {

    func get(
        id: String
    ) async throws -> WebPageDetailsModel
}
