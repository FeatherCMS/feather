import FeatherWebAdmin
import OpenAPIRuntime

protocol AdminViewPageInteractor: Sendable {

    func execute(
        entity: AdminViewPageModel
    ) async throws -> PageDetailsModel
}
