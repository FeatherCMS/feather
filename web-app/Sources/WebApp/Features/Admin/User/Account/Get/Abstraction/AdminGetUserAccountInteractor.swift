import Foundation

protocol AdminGetUserAccountInteractor: Sendable {

    func execute(
        id: String
    ) async throws -> AdminGetUserAccountModel
}
