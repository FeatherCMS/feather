import AuthAdminAPI

protocol AppLoginAuthRepository: Sendable {

    func login(
        _ command: LoginCommandModel
    ) async throws -> LoginResultModel
}
