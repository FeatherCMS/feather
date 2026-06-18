import Hummingbird

struct AppPublicContent {
    let controller: any AppPublicContentController

    init(
        repository: any AppPublicContentRepository,
        themeRenderer: ThemeRenderer,
        themeContextFactory: ThemeContextFactory
    ) {
        self.controller = AppPublicContentDefaultController(
            buildRuntime: {
                (
                    interactor: AppPublicContentDefaultInteractor(
                        repository: repository
                    ),
                    presenter: AppPublicContentDefaultPresenter(
                        themeRenderer: themeRenderer,
                        themeContextFactory: themeContextFactory
                    )
                )
            }
        )
    }
}
