import FeatherAdmin
import Foundation
import OpenAPIRuntime

protocol AdminRemoveWebPageInteractor: Sendable {

    func get(
        id: String
    ) async throws -> WebPageDetailsModel

    func delete(
        id: String
    ) async throws
}
