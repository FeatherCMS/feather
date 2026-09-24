public import FeatherAdmin
public import FeatherContracts

public struct AppPublicContent {
    public let controller: any AppPublicContentController

    public init(
        events: any EventPublisher,
        themeRenderer: any PublicThemeRenderer,
        contentRenderer: any WebContentRenderer,
        webAPIBuilder: WebAPIBuilder,
        publicOrigins: AppPublicOriginConfiguration,
        mediaResolver: MediaResolver
    ) {
        self.controller = AppPublicContentDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AppPublicContentDefaultInteractor(
                        repository: AppPublicContentOpenAPIRepository(
                            api: webAPIBuilder.makeWebApp(context)
                        ),
                        events: events,
                        runtime: .init(
                            request: request,
                            context: context,
                            apiBaseURL: webAPIBuilder.baseURL,
                            publicOrigins: publicOrigins,
                            mediaResolver: mediaResolver
                        )
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
