import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import MediaAdminAPI
import MediaModule
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents


extension Asset.File.Remove {
    struct Router {
        private let routes: Asset.Router.Routes
        let controller: any Asset.File.Remove.Controller.Interface

        init(
            environment: AppEnvironment,
            renderingEngine: any RenderingEngine,
            routes: Asset.Router.Routes
        ) {
            self.routes = routes
            self.controller = Asset.File.Remove.Controller.Default(
                buildRuntime: { request, context in
                    WebAdminRuntime(
                        interactor: Asset.File.Remove.Interactor.Default(
                            repository: Asset.File.Remove.Repository.OpenAPI(
                                api: MediaAdminAPIClient(
                                    environment: environment,
                                    requestContext: context
                                )
                            )
                        ),
                        presenter: Asset.File.Remove.Presenter.Default(
                            request: request,
                            context: context,
                            renderEngine: renderingEngine,
                            routes: routes
                        )
                    )
                },
                routes: routes
            )
        }

        func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
            router.post(routes.file.remove.routerPath, use: controller.remove)
        }
    }
}
