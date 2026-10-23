import BlogModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import WebModuleWebAdmin

extension Post.Status.Controller {
    struct Default: Interface {
        let environment: AppEnvironment
        let routes: Post.Router.Routes

        func post(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response {
            let id = try context.requiredID()
            let payload = try await request.decode(
                as: AdminStatusActionFormInput.self,
                context: context
            )
            let api = API.Client(
                environment: environment,
                requestContext: context
            )
            let details = try await Post.View.Repository.OpenAPI(api: api)
                .get(
                    id: id
                )
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
                referenceType: "blog.post",
                referenceID: id,
                status: targetStatus
            )

            let toast = statusToastContent(for: targetStatus)
            return AdminNotificationFlash.redirect(
                to: payload.normalizedReturnTo ?? routes.posts.path
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
                    message: "Blog post published successfully."
                )
            case "archived":
                return .init(
                    title: "Archived",
                    message: "Blog post archived successfully."
                )
            default:
                return .init(
                    title: "Draft",
                    message: "Blog post moved to draft successfully."
                )
            }
        }
    }
}
