struct AppLoginAuth {
    let controller: any AppLoginAuthController

    init(
        repository: any AppLoginAuthRepository
    ) {
        self.controller = AppLoginAuthDefaultController(
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
