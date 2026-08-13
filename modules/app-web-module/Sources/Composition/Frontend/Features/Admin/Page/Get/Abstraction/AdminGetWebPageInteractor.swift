import FeatherAdmin
import Foundation
import OpenAPIRuntime

protocol AdminGetWebPageInteractor: Sendable {

    func execute(
        entity: AdminGetWebPageModel
    ) async throws -> WebPageDetailsModel
}
