public import FeatherModuleKit
import FeatherWebApp
public import FeatherWebShared
import WebAppAPI
import WebModule

public import struct Foundation.URL

public struct AppPublicContent {
    public let controller: any AppPublicContentController

    public init(
        events: any EventPublisher,
        themeRenderer: any PublicThemeRenderer,
        contentRenderer: any ContentRenderer,
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
                return WebAppRuntime(
                    interactor: AppPublicContentDefaultInteractor(
                        repository: AppPublicContentOpenAPIRepository(
                            api: WebApp.API.Client(
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
