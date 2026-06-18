import Hummingbird

struct AppLogoutUser {
    let controller: any AppLogoutUserController

    init(repository: any AppLogoutUserRepository) {
        self.controller = AppLogoutUserDefaultController(
            buildRuntime: { _, _ in
                (
                    interactor: AppLogoutUserDefaultInteractor(
                        repository: repository
                    ),
                    presenter: AppLogoutUserDefaultPresenter()
                )
            }
        )
    }
}
