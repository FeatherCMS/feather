import Foundation

protocol AdminEditUserAccountRepository: Sendable {

    func get(
        id: String
    ) async throws -> AdminEditUserAccountModel

    func update(
        id: String,
        payload: UserAccountFormPayloadModel
    ) async throws
}
