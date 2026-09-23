struct AppLoginAuth {
    let controller: any AppLoginAuthController

    init(
        repository: any AppLoginAuthRepository,
        usesSecureCookies: Bool
    ) {
        self.controller = AppLoginAuthDefaultController(
            usesSecureCookies: usesSecureCookies,
            buildRuntime: { _, _ in
                (
                    interactor: AppLoginAuthDefaultInteractor(
                        repository: repository
                    ),
                    presenter: AppLoginAuthDefaultPresenter()
                )
            }
        )
    }
}
