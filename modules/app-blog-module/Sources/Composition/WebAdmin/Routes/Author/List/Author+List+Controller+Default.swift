import BlogAdminAPI
import BlogAppAPI
import BlogModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import WebModuleWebAdmin

extension Author.List.Controller {
    struct Default: Interface {
        let environment: AppEnvironment
        let routes: Author.Router.Routes
        let buildRuntime:
            AuthenticatedRuntimeBuilder<
                any Author.List.Interactor.Interface,
                any Author.List.Presenter.Interface
            >

        func get(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse {
            let (interactor, presenter) = buildRuntime((request, context))
            let page = request.queryPage()
            let search = request.querySearch()
            let permissions = context.currentUserPermissions
            let canAccess = context.isCurrentUserAllowed(
                to: Author.Permissions.list
            )
            let emptyModel = Author.List.Model(
                items: [],
                total: 0,
                page: page,
                pageSize: 20
            )

            let model: Author.List.Model
            let error: String?
            if canAccess {
                do {
                    model = try await interactor.list(
                        page: page,
                        search: search
                    )
                    error = nil
                }
                catch let caughtError {
                    model = emptyModel
                    error = caughtError.displayMessage
                }
            }
            else {
                model = emptyModel
                error = nil
            }

            return try await presenter.render(
                model: model,
                permissions: permissions,
                search: search,
                error: error
            )
        }

        func postStatus(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response {
            guard
                context.isCurrentUserAllowed(
                    to: Author.Permissions.update
                )
            else {
                return Response(status: .forbidden)
            }

            let id = try context.requiredID()
            let payload = try await request.decode(
                as: AdminStatusActionFormInput.self,
                context: context
            )
            let details = try await Author.Details.Repository
                .OpenAPI(
                    api: API.Client(
                        environment: environment,
                        requestContext: context
                    )
                )
                .get(id: id)
            let targetStatus = resolvedStatus(
                from: payload,
                current: details.metadata
            )
            try await AdminWebMetadataStatusUpdater(
                api: WebModuleWebAdmin.API.Client(
                    environment: environment,
                    requestContext: context
                )
            )
            .update(
                referenceType: "blog.author",
                referenceID: id,
                status: targetStatus
            )
            let toast = statusToastContent(for: targetStatus)
            return AdminNotificationFlash.redirect(
                to: payload.normalizedReturnTo ?? routes.authors.description
                    + "/",
                notification: .init(title: toast.title, message: toast.message)
            )
        }

        private func resolvedStatus(
            from payload: AdminStatusActionFormInput,
            current metadata: AdminMetadataFormValue
        ) -> String {
            let allowedStatuses = Set(["draft", "published", "archived"])
            let selectedStatus = payload.normalizedStatus
            return allowedStatuses.contains(selectedStatus)
                ? selectedStatus
                : metadata.normalizedStatus
        }

        private func statusToastContent(
            for status: String
        ) -> (title: String, message: String) {
            switch status {
            case "published":
                return ("Published", "Blog author published successfully.")
            case "archived":
                return ("Archived", "Blog author archived successfully.")
            default:
                return ("Draft", "Blog author moved to draft successfully.")
            }
        }
    }
}
