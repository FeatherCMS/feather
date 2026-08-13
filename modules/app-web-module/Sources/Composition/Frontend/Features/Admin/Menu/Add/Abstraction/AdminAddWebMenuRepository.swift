import FeatherAdmin
import Foundation
import OpenAPIRuntime

protocol AdminAddWebMenuRepository: Sendable {

    func create(
        input: WebMenuFormInput
    ) async throws
}
