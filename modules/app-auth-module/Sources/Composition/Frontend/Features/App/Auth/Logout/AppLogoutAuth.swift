struct AppLogoutAuth {
    let controller: any AppLogoutAuthController

    init(repository: any AppLogoutAuthRepository) {
        self.controller = AppLogoutAuthDefaultController(
            buildRuntime: { _, _ in
                (
                    interactor: AppLogoutAuthDefaultInteractor(
                        repository: repository
                    ),
                    presenter: AppLogoutAuthDefaultPresenter()
                )
            }
        )
    }
}
