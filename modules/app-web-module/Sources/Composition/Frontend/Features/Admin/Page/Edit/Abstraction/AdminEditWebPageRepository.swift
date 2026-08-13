import FeatherAdmin
import Foundation
import OpenAPIRuntime

protocol AdminEditWebPageRepository: Sendable {

    func load(
        id: String
    ) async throws -> WebPageDetailsModel

    func update(
        id: String,
        input: WebPageFormInput
    ) async throws
}
