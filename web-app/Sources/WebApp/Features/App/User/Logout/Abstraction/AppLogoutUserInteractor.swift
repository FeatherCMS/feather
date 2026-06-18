import Foundation

protocol AppLogoutUserInteractor: Sendable {

    func execute(
        entity: AppLogoutUserModel
    ) async
}
