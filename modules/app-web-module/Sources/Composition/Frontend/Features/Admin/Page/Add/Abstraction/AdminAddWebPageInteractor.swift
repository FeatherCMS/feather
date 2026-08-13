import FeatherAdmin
import Foundation
import OpenAPIRuntime

protocol AdminAddWebPageInteractor: Sendable {

    func execute(
        input: WebPageFormInput
    ) async throws
}
