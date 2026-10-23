import AccountModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import OpenAPIRuntime
import UserAdminAPI
import UserWebAdmin

extension Invitation.Detail {
    struct Router {
        let controller: any Invitation.Detail.Controller.Interface
        let routes: Invitation.Router.Routes

        init(
            environment: AppEnvironment,
            renderingEngine: any RenderingEngine,
            routes: Invitation.Router.Routes
        ) {
            self.routes = routes
            self.controller = Invitation.Detail.Controller.Default(
                buildRuntime: { request, context in
                    WebAdminRuntime(
                        interactor: Invitation.Detail.Interactor.Default(
                            repository: Invitation.Detail.Repository.OpenAPI(
                                api: API.Client(
                                    environment: environment,
                                    requestContext: context
                                )
                            ),
                            roleNamesProvider: { roleIDs in
                                let userAPI = UserWebAdmin.API.Client(
                                    apiBaseURL: environment.apiBaseURL,
                                    requestContext: context
                                )
                                guard
                                    let response =
                                        try? await userAPI
                                        .withOpenAPIRepositoryErrorMapping({
                                            client in
                                            try await client.userRoleList(
                                                query: .init(limit: 100),
                                                headers: .init(accept: [
                                                    .init(contentType: .json)
                                                ])
                                            )
                                        }),
                                    case .ok(let value) = response,
                                    let body = try? value.body.json
                                else { return roleIDs }
                                let namesByID = Dictionary(
                                    uniqueKeysWithValues: body.map {
                                        ($0.id, $0.name ?? $0.id)
                                    }
                                )
                                return roleIDs.map { namesByID[$0] ?? $0 }
                            }
                        ),
                        presenter: Invitation.Detail.Presenter.Default(
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
                use: controller.getAccountInvitation
            )
        }
    }
}
