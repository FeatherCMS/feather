import Foundation

struct AppLogoutUserDefaultInteractor: AppLogoutUserInteractor {
    private let repository: any AppLogoutUserRepository

    init(repository: any AppLogoutUserRepository) {
        self.repository = repository
    }

    func execute(
        entity: AppLogoutUserModel
    ) async {
        try? await repository.logout(sessionToken: entity.sessionToken)
    }
}
