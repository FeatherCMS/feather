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


extension Asset.Folder.Edit {
    struct Router {
        private let routes: Asset.Router.Routes
        let controller: any Asset.Folder.Edit.Controller.Interface

        init(
            environment: AppEnvironment,
            renderingEngine: any RenderingEngine,
            routes: Asset.Router.Routes
        ) {
            self.routes = routes
            self.controller = Asset.Folder.Edit.Controller.Default(
                buildRuntime: { request, context in
                    WebAdminRuntime(
                        interactor: Asset.Folder.Edit.Interactor.Default(
                            repository: Asset.Folder.Edit.Repository.OpenAPI(
                                api: MediaAdminAPIClient(
                                    environment: environment,
                                    requestContext: context
                                )
                            )
                        ),
                        presenter: Asset.Folder.Edit.Presenter.Default(
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
                routes.folder.edit.routerPath,
                use: controller.getEditMediaFolder
            )
            router.post(
                routes.folder.edit.routerPath,
                use: controller.postEditMediaFolder
            )
        }
    }
}
