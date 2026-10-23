import BlogAdminAPI
import BlogAppAPI
import BlogModule
import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import MediaWebAdmin
import OpenAPIRuntime
import WebBuilders
import WebComponents
import WebModuleWebAdmin

extension Tag.List.Controller {
    struct Default: Interface {
        let environment: AppEnvironment
        let routes: Tag.Router.Routes
        let buildRuntime:
            @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
                any Tag.List.Interactor.Interface,
                any Tag.List.Presenter.Interface
            >

        func get(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse {
            let __runtimeBuild1 = buildRuntime(request, context)
            let interactor = __runtimeBuild1.interactor
            let presenter = __runtimeBuild1.presenter
            let page = request.queryPage()
            let search = request.querySearch()
            let permissions = context.currentUserPermissions
            let canAccess = context.isCurrentUserAllowed(
                to: Tag.Permissions.list
            )
            let emptyModel = Tag.List.Model(
                items: [],
                total: 0,
                page: page,
                pageSize: 20
            )
            let model: Tag.List.Model
            let error: String?
            if canAccess {
                do {
                    model = try await interactor.execute(
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
            let id = try context.requiredID()
            let payload = try await request.decode(
                as: AdminStatusActionFormInput.self,
                context: context
            )
            let repository = Tag.View.Repository.OpenAPI(
                api: API.Client(
                    environment: environment,
                    requestContext: context
                )
            )
            let details = try await repository.get(id: id)
            let targetStatus = resolvedStatus(
                from: payload,
                current: details.metadata
            )
            try await AdminMetadataStatusUpdater(
                api: WebModuleWebAdmin.API.Client(
                    environment: environment,
                    requestContext: context
                )
            )
            .update(
                referenceType: "blog.tag",
                referenceID: id,
                status: targetStatus
            )
            let toast = statusToastContent(for: targetStatus)
            return AdminNotificationFlash.redirect(
                to: payload.normalizedReturnTo ?? routes.tags.path
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
                    kind: .success,
                    title: "Published",
                    message: "Blog tag published successfully."
                )
            case "archived":
                return .init(
                    kind: .success,
                    title: "Archived",
                    message: "Blog tag archived successfully."
                )
            default:
                return .init(
                    kind: .success,
                    title: "Draft",
                    message: "Blog tag moved to draft successfully."
                )
            }
        }
    }
}
