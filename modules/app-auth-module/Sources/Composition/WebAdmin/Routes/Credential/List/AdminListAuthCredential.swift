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

struct AdminListAuthCredential {
    let controller: any AdminListAuthCredentialController
    let routes: Credential.Router.Routes

    init(
        environment: AppEnvironment,
        renderingEngine: any RenderingEngine,
        routes: Credential.Router.Routes
    ) {
        self.routes = routes
        controller = AdminListAuthCredentialDefaultController(
            routes: routes,
            buildRuntime: { request, context in
                (
                    interactor: AdminListAuthCredentialDefaultInteractor(
                        repository: AdminListAuthCredentialOpenAPIRepository(
                            api: API.Client(
                                environment: environment,
                                requestContext: context
                            )
                        )
                    ),
                    presenter: AdminListAuthCredentialDefaultPresenter(
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
