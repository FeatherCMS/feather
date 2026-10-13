struct AppLogoutAuth {
    let controller: any AppLogoutAuthController

    init(
        repository: any AppLogoutAuthRepository,
        usesSecureCookies: Bool
    ) {
        self.controller = AppLogoutAuthDefaultController(
            buildRuntime: { _, _ in
                (
                    interactor: AppLogoutAuthDefaultInteractor(
                        repository: repository
                    ),
                    presenter: AppLogoutAuthDefaultPresenter(
                        usesSecureCookies: usesSecureCookies
                    )
                )
            }
        )
    }
}
