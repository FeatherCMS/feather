import Foundation

struct AppLoginUserDefaultInteractor: AppLoginUserInteractor {
    let repository: any AppLoginUserRepository

    func execute(
        entity: AppLoginUserModel
    ) async throws -> LoginResultModel {
        try await repository.login(entity.command)
    }
}
