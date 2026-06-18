import Foundation

protocol AppLoginUserInteractor: Sendable {

    func execute(
        entity: AppLoginUserModel
    ) async throws -> LoginResultModel
}
