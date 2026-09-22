struct AppLogoutAuthDefaultInteractor: AppLogoutAuthInteractor {
    private let repository: any AppLogoutAuthRepository

    init(repository: any AppLogoutAuthRepository) {
        self.repository = repository
    }

    func execute(
        entity: AppLogoutAuthModel
    ) async {
        try? await repository.logout(sessionToken: entity.sessionToken)
    }
}
