import Hummingbird

struct AppGetHome {
    let controller: any AppGetHomeController

    init(
        repository: any AppPublicContentRepository,
        themeRenderer: ThemeRenderer,
        themeContextFactory: ThemeContextFactory
    ) {
        self.controller = AppGetHomeDefaultController(
            buildRuntime: { request, _ in
                (
                    interactor: AppGetHomeDefaultInteractor(
                        repository: repository
                    ),
                    presenter: AppGetHomeDefaultPresenter(
                        request: request,
                        themeRenderer: themeRenderer,
                        themeContextFactory: themeContextFactory
                    )
                )
            }
        )
    }
}
