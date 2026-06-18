import Foundation

protocol AdminRemoveUserAccountInteractor: Sendable {

    func execute(
        entity: AdminRemoveUserAccountModel
    ) async throws
}
