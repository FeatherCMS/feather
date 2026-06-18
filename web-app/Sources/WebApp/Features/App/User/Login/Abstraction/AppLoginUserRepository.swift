import Foundation

protocol AppLoginUserRepository: Sendable {

    func login(
        _ command: LoginCommandModel
    ) async throws -> LoginResultModel
}
