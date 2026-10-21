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

struct AdminEditAuthCredential {
    let controller: any AdminEditAuthCredentialController
    let routes: Credential.Router.Routes

    init(
        environment: AppEnvironment,
        renderingEngine: any RenderingEngine,
        routes: Credential.Router.Routes
    ) {
        self.routes = routes
        controller = AdminEditAuthCredentialDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminEditAuthCredentialDefaultInteractor(
                        repository: AdminEditAuthCredentialOpenAPIRepository(
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
                    presenter: AdminEditAuthCredentialDefaultPresenter(
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
