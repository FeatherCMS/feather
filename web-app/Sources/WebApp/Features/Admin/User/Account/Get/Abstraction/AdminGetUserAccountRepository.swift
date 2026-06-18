import AdminOpenAPI
import Foundation

protocol AdminGetUserAccountRepository: Sendable {

    func get(
        id: String
    ) async throws -> UserAccountDetailsModel
    func getSessions(
        id: String
    ) async throws -> [Components.Schemas.UserAuthSessionListItemSchema]
}
