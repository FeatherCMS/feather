import Hummingbird

struct AppLoginUser {
    let controller: any AppLoginUserController

    init(
        repository: any AppLoginUserRepository,
        renderingEngine: any RenderingEngine
    ) {
        self.controller = AppLoginUserDefaultController(
            buildRuntime: { request, _ in
                (
                    interactor: AppLoginUserDefaultInteractor(
                        repository: repository
                    ),
                    presenter: AppLoginUserDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
