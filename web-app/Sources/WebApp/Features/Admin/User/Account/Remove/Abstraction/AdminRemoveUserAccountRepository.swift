import Foundation

protocol AdminRemoveUserAccountRepository: Sendable {

    func delete(
        id: String
    ) async throws
}
