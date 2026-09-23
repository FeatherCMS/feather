import FeatherAdmin
import FeatherContracts

public struct AppPublicContent {
    public let controller: any AppPublicContentController

    public init(
        events: any EventPublisher,
        themeRenderer: any PublicThemeRenderer,
        contentRenderer: any WebContentRenderer
    ) {
        self.controller = AppPublicContentDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AppPublicContentDefaultInteractor(
                        repository: AppPublicContentOpenAPIRepository(
                            api: context.webApplicationAPI()
                        ),
                        events: events,
                        runtime: (request, context)
                    ),
                    presenter: AppPublicContentDefaultPresenter(
                        themeRenderer: themeRenderer,
                        contentRenderer: contentRenderer
                    )
                )
            }
        )
    }
}
