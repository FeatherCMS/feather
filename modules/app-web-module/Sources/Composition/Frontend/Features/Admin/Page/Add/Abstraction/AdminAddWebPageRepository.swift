import FeatherAdmin
import Foundation
import OpenAPIRuntime

protocol AdminAddWebPageRepository: Sendable {

    func create(
        input: WebPageFormInput
    ) async throws
}
