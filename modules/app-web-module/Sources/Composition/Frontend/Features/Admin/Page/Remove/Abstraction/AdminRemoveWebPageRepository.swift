import FeatherAdmin
import Foundation
import OpenAPIRuntime

protocol AdminRemoveWebPageRepository: Sendable {

    func get(
        id: String
    ) async throws -> WebPageDetailsModel

    func delete(
        id: String
    ) async throws
}
