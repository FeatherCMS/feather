public import FeatherModuleKit
import FeatherWebApp
public import FeatherWebShared
public import Hummingbird
import WebAppAPI
import WebModule

public import struct Foundation.URL

extension Public.Content {
    public struct Router {
        private enum Routes {
            static let rss = WebRoute.root.appending(pathComponent: "rss.xml")
            static let sitemap = WebRoute.root.appending(
                pathComponent: "sitemap.xml"
            )
        }

        private let controller: any Controller.Interface

        public init(
            events: any EventPublisher,
            themeRenderer: any PublicThemeRenderer,
            contentRenderer: any ContentRenderer,
            apiBaseURL: URL,
            publicOrigins: AppPublicOriginConfiguration,
            mediaResolver: MediaResolver
        ) {
            self.controller = Controller.Default(
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
                        interactor: Interactor.Default(
                            repository: Repository.OpenAPI(
                                api: API.Client(
                                    apiBaseURL: runtime.apiBaseURL,
                                    sessionToken: runtime.context.sessionToken
                                )
                            ),
                            events: events,
                            runtime: runtime
                        ),
                        presenter: Presenter.Default(
                            themeRenderer: themeRenderer,
                            contentRenderer: contentRenderer
                        )
                    )
                }
            )
        }

        public func route(
            on router: Hummingbird.Router<DefaultRequestContext>
        ) {
            router.get(Routes.rss.routerPath, use: controller.getRSS)
            router.get(Routes.sitemap.routerPath, use: controller.getSitemap)
            router.get(WebRoute.root.routerPath, use: controller.getContent)
            router.get("/**", use: controller.getContent)
        }
    }
}
