struct AppLoginAuth {
    let controller: any AppLoginAuthController

    init(
        repository: any AppLoginAuthRepository,
        usesSecureCookies: Bool,
        turnstileVerifier: (any AuthTurnstileVerifier)? = nil
    ) {
        self.controller = AppLoginAuthDefaultController(
            usesSecureCookies: usesSecureCookies,
            turnstileVerifier: turnstileVerifier,
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
