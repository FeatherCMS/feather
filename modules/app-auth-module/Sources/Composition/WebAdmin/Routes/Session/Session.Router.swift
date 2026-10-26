import AuthModule
import FeatherWebAdmin
import FeatherWebShared
import Foundation
import Hummingbird

extension Session {

    struct Router {
        struct Routes {
            let admin: WebRoute
            let auth: WebRoute
            let identityRoot: WebRoute
            let identity: WebRoute
            let list: WebRoute
            let remove: WebRoute
            let magicLinks: WebRoute

            init(
                admin: WebRoute,
                auth: WebRoute,
                identityRoot: WebRoute,
                magicLinks: WebRoute
            ) {
                self.admin = admin
                self.auth = auth
                self.identityRoot = identityRoot
                self.magicLinks = magicLinks
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
                    .init(label: "Admin", link: admin.path),
                    .init(label: "Auth", link: auth.path),
                    .init(label: "Identities", link: identityRoot.path),
                    .init(
                        label: "Details",
                        link: identityPath(identityID)
                    ),
                ]
            }

            func identityPath(_ identityID: String) -> String {
                identity.path(parameter: "identityId", value: identityID)
            }

            func listPath(identityID: String) -> String {
                list.path(parameter: "identityId", value: identityID)
            }

            func magicLinksPath(identityID: String) -> String {
                var components = URLComponents(string: magicLinks.path)!
                components.queryItems = [
                    URLQueryItem(name: "userId", value: identityID)
                ]
                return components.string ?? magicLinks.path
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
            List
                .Router(
                    environment: environment,
                    renderingEngine: renderingEngine,
                    routes: routes
                )
                .route(on: router)
            Remove
                .Router(
                    environment: environment,
                    renderingEngine: renderingEngine,
                    routes: routes
                )
                .route(on: router)
        }
    }
}
