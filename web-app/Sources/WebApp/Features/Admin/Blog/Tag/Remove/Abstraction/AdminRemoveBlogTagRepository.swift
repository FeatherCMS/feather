import Foundation

protocol AdminRemoveBlogTagRepository: Sendable {

    func get(
        id: String
    ) async throws -> BlogTagDetailsModel

    func delete(
        id: String
    ) async throws
}
