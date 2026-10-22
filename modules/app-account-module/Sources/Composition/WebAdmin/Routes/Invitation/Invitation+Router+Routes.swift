import AccountModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Invitation {
    struct Router {
        struct Routes: Sendable {
            let invitations: WebRoute
            let invitationAdd: WebRoute
            let invitationRemoveBulk: WebRoute
            let invitationDetailsPattern: WebRoute
            let invitationEditPattern: WebRoute
            let invitationRemovePattern: WebRoute
            let invitationResendPattern: WebRoute
            let invitationBreadcrumb: [AdminBreadcrumb.Link]

            init(root: WebRoute) {
                let account = root.appending(pathComponent: "account")
                let invitations = account.appending(
                    pathComponent: "invitations"
                )
                let details = invitations.appending(parameter: "id")
                self.invitations = invitations
                self.invitationAdd = invitations.appending(pathComponent: "add")
                self.invitationRemoveBulk = invitations.appending(
                    pathComponent: "remove"
                )
                self.invitationDetailsPattern = details
                self.invitationEditPattern = details.appending(
                    pathComponent: "edit"
                )
                self.invitationRemovePattern = details.appending(
                    pathComponent: "remove"
                )
                self.invitationResendPattern = details.appending(
                    pathComponent: "resend"
                )
                self.invitationBreadcrumb = [
                    .init(label: "Admin", link: "/admin/"),
                    .init(label: "Account", link: account.path),
                    .init(label: "Invitations", link: invitations.path),
                ]
            }

            func invitationDetails(_ id: String) -> String {
                invitations.appending(pathComponent: id).path
            }

            func invitationEdit(_ id: String) -> String {
                invitations.appending(pathComponent: id)
                    .appending(pathComponent: "edit").path
            }

            func invitationRemove(_ id: String) -> String {
                invitations.appending(pathComponent: id)
                    .appending(pathComponent: "remove").path
            }

            func invitationResend(_ id: String) -> String {
                invitations.appending(pathComponent: id)
                    .appending(pathComponent: "resend").path
            }

            func invitationDetailsBreadcrumb(_ id: String) -> [AdminBreadcrumb
                .Link]
            {
                invitationBreadcrumb + [
                    .init(label: "Details", link: invitationDetails(id))
                ]
            }

            func invitationEditBreadcrumb(_ id: String) -> [AdminBreadcrumb
                .Link]
            {
                invitationDetailsBreadcrumb(id) + [
                    .init(label: "Edit", link: invitationEdit(id))
                ]
            }

            func invitationRemoveBreadcrumb(_ id: String) -> [AdminBreadcrumb
                .Link]
            {
                invitationBreadcrumb + [
                    .init(label: "Remove", link: invitationRemove(id))
                ]
            }
        }

        let routes: Routes
        private let environment: AppEnvironment
        private let renderingEngine: any RenderingEngine

        init(
            environment: AppEnvironment,
            renderingEngine: any RenderingEngine,
            routes: Routes
        ) {
            self.environment = environment
            self.renderingEngine = renderingEngine
            self.routes = routes
        }

        func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
            List.Router(
                environment: environment,
                renderingEngine: renderingEngine,
                routes: routes
            )
            .route(on: router)
            Detail.Router(
                environment: environment,
                renderingEngine: renderingEngine,
                routes: routes
            )
            .route(on: router)
            Add.Router(
                environment: environment,
                renderingEngine: renderingEngine,
                routes: routes
            )
            .route(on: router)
            Edit.Router(
                environment: environment,
                renderingEngine: renderingEngine,
                routes: routes
            )
            .route(on: router)
            Remove.Router(
                environment: environment,
                renderingEngine: renderingEngine,
                routes: routes
            )
            .route(on: router)
            Resend.Router(environment: environment, routes: routes)
                .route(on: router)
        }
    }
}
