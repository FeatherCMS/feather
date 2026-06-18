import Foundation

protocol AdminAddUserAccountInteractor: Sendable {

    func execute(
        entity: AdminAddUserAccountModel
    ) async throws
}
