import Foundation

protocol AdminAddUserAccountRepository: Sendable {

    func create(
        payload: UserAccountFormPayloadModel
    ) async throws
}
