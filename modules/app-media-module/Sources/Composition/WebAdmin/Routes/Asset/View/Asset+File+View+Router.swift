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

extension Asset.File {
    enum View {
        enum Controller {}
        enum Interactor {}
        enum Presenter {}
        enum Repository {}
    }
}

extension Asset.File.View {
    struct Router {
        private let routes: Asset.Router.Routes
        let controller: any Asset.File.View.Controller.Interface

        init(
            environment: AppEnvironment,
            renderingEngine: any RenderingEngine,
            routes: Asset.Router.Routes
        ) {
            self.routes = routes
            self.controller = Asset.File.View.Controller.Default(
                buildRuntime: { request, context in
                    (
                        interactor: Asset.File.View.Interactor.Default(
                            repository: Asset.File.View.Repository.OpenAPI(
                                api: MediaAdminAPIClient(
                                    environment: environment,
                                    requestContext: context
                                )
                            )
                        ),
                        presenter: Asset.File.View.Presenter.Default(
                            request: request,
                            context: context,
                            renderEngine: renderingEngine,
                            routes: routes
                        )
                    )
                }
            )
        }

        func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
            router.get(
                routes.file.details.routerPath,
                use: controller.getMediaAsset
            )
        }
    }
}
