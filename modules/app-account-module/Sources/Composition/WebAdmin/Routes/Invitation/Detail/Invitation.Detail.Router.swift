import AccountModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import UserWebAdmin

extension Invitation.Detail {
    struct Router {
        let controller: any Controller.Interface
        let routes: Invitation.Router.Routes

        init(
            environment: AppEnvironment,
            renderingEngine: any RenderingEngine,
            routes: Invitation.Router.Routes
        ) {
            self.routes = routes
            self.controller = Controller.Default(
                buildRuntime: { request, context in
                    WebAdminRuntime(
                        interactor: Interactor.Default(
                            repository: Repository.OpenAPI(
                                api: API.Client(
                                    environment: environment,
                                    requestContext: context
                                )
                            ),
                            roleNamesProvider: { roleIDs in
                                let roles = await Invitation.Form.Repository.Role
                                    .OpenAPI(
                                        api: UserWebAdmin.API.Client(
                                            environment: environment,
                                            requestContext: context
                                        )
                                    )
                                    .list()
                                var namesByID: [String: String] = [:]
                                for role in roles {
                                    precondition(
                                        namesByID.updateValue(
                                            role.name,
                                            forKey: role.id
                                        ) == nil
                                    )
                                }
                                return roleIDs.map { namesByID[$0] ?? $0 }
                            }
                        ),
                        presenter: Presenter.Default(
                            request: request,
                            context: context,
                            renderingEngine: renderingEngine,
                            routes: routes
                        ),
                    )
                }
            )
        }

        func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
            router.get(
                routes.invitationDetailsPattern.routerPath,
                use: controller.getDetail
            )
        }
    }
}
