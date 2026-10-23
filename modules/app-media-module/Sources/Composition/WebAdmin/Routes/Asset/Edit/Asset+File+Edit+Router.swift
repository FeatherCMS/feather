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


extension Asset.File.Edit {
    struct Router {
        private let routes: Asset.Router.Routes
        let controller: any Asset.File.Edit.Controller.Interface

        init(
            environment: AppEnvironment,
            renderingEngine: any RenderingEngine,
            routes: Asset.Router.Routes
        ) {
            self.routes = routes
            self.controller = Asset.File.Edit.Controller.Default(
                buildRuntime: { request, context in
                    WebAdminRuntime(
                        interactor: Asset.File.Edit.Interactor.Default(
                            repository: Asset.File.Edit.Repository.OpenAPI(
                                api: MediaAdminAPIClient(
                                    environment: environment,
                                    requestContext: context
                                )
                            )
                        ),
                        presenter: Asset.File.Edit.Presenter.Default(
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
            router.get(
                routes.file.edit.routerPath,
                use: controller.getEditMediaAsset
            )
            router.post(
                routes.file.edit.routerPath,
                use: controller.postEditMediaAsset
            )
        }
    }
}
