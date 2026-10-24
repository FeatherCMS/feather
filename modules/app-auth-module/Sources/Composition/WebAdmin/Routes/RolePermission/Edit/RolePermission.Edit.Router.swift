import AuthAdminAPI
import AuthModule
import CSS
import FeatherValidation
import FeatherValidationFoundation
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import SystemAdminAPI
import SystemWebAdmin
import UserAdminAPI
import UserWebAdmin
import WebBuilders
import WebComponents

extension RolePermission.Edit {
    struct Router {

        let controller: any RolePermission.Edit.Controller.Interface

        init(
            environment: AppEnvironment,
            renderingEngine: any RenderingEngine,
            routes: RolePermission.Router.Routes
        ) {
            self.controller = RolePermission.Edit.Controller.Default(
                buildRuntime: { request, context in
                    WebAdminRuntime(
                        interactor: RolePermission.Edit.Interactor.Default(
                            repository: RolePermission.Edit.Repository.OpenAPI(
                                api: API.Client(
                                    environment: environment,
                                    requestContext: context
                                ),
                                userAPI: UserWebAdmin.API.Client(
                                    environment: environment,
                                    requestContext: context
                                ),
                                systemAPI: SystemWebAdmin.API.Client(
                                    environment: environment,
                                    requestContext: context
                                )
                            )
                        ),
                        presenter: RolePermission.Edit.Presenter.Default(
                            request: request,
                            context: context,
                            renderEngine: renderingEngine,
                            routes: routes
                        )
                    )
                }
            )
        }
    }
}
