
struct AppLoginAuthDefaultInteractor: AppLoginAuthInteractor {
    let repository: any AppLoginAuthRepository

    func execute(
        entity: AppLoginAuthModel
    ) async throws -> LoginResultModel {
        try await repository.login(entity.command)
    }
}
