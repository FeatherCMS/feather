import FeatherWebAdmin
import OpenAPIRuntime

protocol AdminViewWebPageInteractor: Sendable {

    func execute(
        entity: AdminViewWebPageModel
    ) async throws -> WebPageDetailsModel
}
