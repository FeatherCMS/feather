import Foundation

protocol AdminGetWebPageInteractor: Sendable {

    func execute(
        entity: AdminGetWebPageModel
    ) async throws -> WebPageDetailsModel
}
