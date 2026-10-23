import BlogAdminAPI
import BlogAppAPI
import BlogModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import WebModule
import WebModuleWebAdmin

extension Author.List.Controller {
    struct Default: Interface {
        let environment: AppEnvironment
        let routes: Author.Router.Routes
        let buildRuntime:
            @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
                any Author.List.Interactor.Interface,
                any Author.List.Presenter.Interface
            >

        func get(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse {
            let runtime = buildRuntime(request, context)
            let interactor = runtime.interactor
            let presenter = runtime.presenter
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
            let details = try await Author.View.Repository
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
            try await WebModule.Metadata
                .StatusUpdater(
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
                to: payload.normalizedReturnTo ?? routes.authors.path
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
        ) -> AdminNotification.State {
            switch status {
            case "published":
                return .init(
                    title: "Published",
                    message: "Blog author published successfully."
                )
            case "archived":
                return .init(
                    title: "Archived",
                    message: "Blog author archived successfully."
                )
            default:
                return .init(
                    title: "Draft",
                    message: "Blog author moved to draft successfully."
                )
            }
        }
    }
}
