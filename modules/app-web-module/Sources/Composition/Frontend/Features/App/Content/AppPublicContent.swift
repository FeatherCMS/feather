public import FeatherAdmin
public import FeatherContracts
import WebContracts
import WebAppAPI

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
            usesSecureCookies: publicOrigins.usesSecureCookies,
            buildRSS: { request, context in
                let runtime = PublicContentRuntimeContext(
                    request: request,
                    context: context,
                    apiBaseURL: webAPIBuilder.baseURL,
                    publicOrigins: publicOrigins,
                    mediaResolver: mediaResolver
                )
                let results = try await events.trigger(
                    event: WebRSSContentProvider(),
                    using: WebRSSContentEventContext(runtime: runtime)
                )
                let settings = try await webAPIBuilder
                    .makeWebApp(context)
                    .publicSiteSettings()
                return PublicRSSXML.render(
                    title: settings.title,
                    description: settings.excerpt,
                    siteURL: publicOrigins.siteBaseURL,
                    items: results.flatMap { $0 }
                )
            },
            buildSitemap: { context in
                let slugs = try await webAPIBuilder
                    .makeWebApp(context)
                    .publicMetadataSlugs()
                return PublicSitemapXML.render(
                    slugs: slugs,
                    baseURL: publicOrigins.siteBaseURL
                )
            },
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
