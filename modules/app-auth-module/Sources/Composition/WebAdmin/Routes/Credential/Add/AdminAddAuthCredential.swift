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

struct AdminAddAuthCredential {
    let controller: any AdminAddAuthCredentialController
    let routes: Credential.Router.Routes

    init(
        environment: AppEnvironment,
        renderingEngine: any RenderingEngine,
        routes: Credential.Router.Routes
    ) {
        self.routes = routes
        controller = AdminAddAuthCredentialDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminAddAuthCredentialDefaultInteractor(
                        repository: AdminAddAuthCredentialOpenAPIRepository(
                            api: API.Client(
                                environment: environment,
                                requestContext: context
                            ),
                            userAPI: UserWebAdmin.API.Client(
                                apiBaseURL: environment.apiBaseURL,
                                requestContext: context
                            )
                        )
                    ),
                    presenter: AdminAddAuthCredentialDefaultPresenter(
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
