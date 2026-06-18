import Foundation

protocol AdminGetWebMenuRepository: Sendable {

    func get(
        id: String
    ) async throws -> WebMenuDetailsModel
}
