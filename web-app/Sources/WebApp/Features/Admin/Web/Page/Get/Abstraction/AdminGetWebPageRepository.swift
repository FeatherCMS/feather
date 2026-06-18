import Foundation

protocol AdminGetWebPageRepository: Sendable {

    func get(
        id: String
    ) async throws -> WebPageDetailsModel
}
