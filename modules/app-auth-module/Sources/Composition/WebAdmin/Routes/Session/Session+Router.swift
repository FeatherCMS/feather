import AuthModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Session {
    enum List {
        enum Controller {}
        enum Interactor {}
        enum Presenter {}
        enum Repository {}
    }
    enum Remove {
        enum Controller {}
        enum Interactor {}
        enum Presenter {}
        enum Repository {}
    }

    struct Router {
        struct Routes {
            let identityRoot: WebRoute
            let identity: WebRoute
            let list: WebRoute
            let remove: WebRoute

            init(identityRoot: WebRoute) {
                self.identityRoot = identityRoot
                identity = identityRoot.appending(parameter: "identityId")
                list = identity.appending(pathComponent: "sessions")
                remove =
                    list
                    .appending(parameter: "sessionId")
                    .appending(pathComponent: "remove")
            }

            func detailsBreadcrumb(identityID: String) -> [AdminBreadcrumb.Link]
            {
                [
                    .init(label: "Admin", link: "/admin/"),
                    .init(label: "User", link: "/admin/user/"),
                    .init(label: "Identities", link: identityRoot.path),
                    .init(
                        label: "Details",
                        link: identity.path(
                            parameter: "identityId",
                            value: identityID
                        )
                    ),
                ]
            }

            func removePath(identityID: String, sessionID: String) -> String {
                do {
                    return try remove.path(
                        parameters: [
                            "identityId": identityID,
                            "sessionId": sessionID,
                        ]
                    )
                }
                catch {
                    preconditionFailure(
                        "Session remove route parameters are incomplete."
                    )
                }
            }

        }

        let routes: Routes
        let environment: AppEnvironment
        let renderingEngine: any RenderingEngine

        func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
            Session.List
                .Router(
                    environment: environment,
                    renderingEngine: renderingEngine
                )
                .controller.route(on: router, routes: routes)
            Session.Remove
                .Router(
                    environment: environment,
                    renderingEngine: renderingEngine,
                    routes: routes
                )
                .controller.route(on: router, routes: routes)
        }
    }
}
