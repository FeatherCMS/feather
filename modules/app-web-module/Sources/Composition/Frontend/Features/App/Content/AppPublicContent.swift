import FeatherAdmin
import FeatherContracts

public struct AppPublicContent {
    public let controller: any AppPublicContentController

    public init(
        repository: any AppPublicContentRepository,
        events: any EventPublisher,
        themeRenderer: any PublicThemeRenderer,
        contentRenderer: any WebContentRenderer
    ) {
        self.controller = AppPublicContentDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AppPublicContentDefaultInteractor(
                        repository: repository.withSessionToken(
                            context.sessionToken
                        ),
                        events: events,
                        sessionToken: context.sessionToken,
                        contentRenderer: contentRenderer
                    ),
                    presenter: AppPublicContentDefaultPresenter(
                        themeRenderer: themeRenderer
                    )
                )
            }
        )
    }
}
