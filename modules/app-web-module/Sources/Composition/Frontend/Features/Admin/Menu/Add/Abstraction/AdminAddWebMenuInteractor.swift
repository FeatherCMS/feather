import FeatherAdmin
import Foundation
import OpenAPIRuntime

protocol AdminAddWebMenuInteractor: Sendable {

    func execute(
        input: WebMenuFormInput
    ) async throws
}
