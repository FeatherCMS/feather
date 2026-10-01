public import FeatherAdmin
public import FeatherContracts
public import struct Foundation.URL
import WebAppAPI
import WebContracts

public struct AppPublicContent {
    public let controller: any AppPublicContentController

    public init(
        events: any EventPublisher,
        themeRenderer: any PublicThemeRenderer,
        contentRenderer: any WebContentRenderer,
        apiBaseURL: URL,
        publicOrigins: AppPublicOriginConfiguration,
        mediaResolver: MediaResolver
    ) {
        self.controller = AppPublicContentDefaultController(
            usesSecureCookies: publicOrigins.usesSecureCookies,
            buildRuntime: { request, context in
                let runtime = PublicContentRuntimeContext(
                    request: request,
                    context: context,
                    apiBaseURL: apiBaseURL,
                    publicOrigins: publicOrigins,
                    mediaResolver: mediaResolver
                )
                return (
                    interactor: AppPublicContentDefaultInteractor(
                        repository: AppPublicContentOpenAPIRepository(
                            api: WebAppAPIClient(
                                apiBaseURL: runtime.apiBaseURL,
                                sessionToken: runtime.context.sessionToken
                            )
                        ),
                        events: events,
                        runtime: runtime
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
