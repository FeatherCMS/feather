import FeatherModuleKit
import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import Foundation
import HTML
import Hummingbird
import MediaAdminAPI
import MediaModule
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

extension Asset.Folder.Add.Controller {
    struct Default: Interface {
        let buildRuntime:
            @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
                any Asset.Folder.Add.Interactor.Interface,
                any Asset.Folder.Add.Presenter.Interface
            >
        let routes: Asset.Router.Routes

        func getAddMediaFolder(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse {
            let runtime = buildRuntime(request, context)
            let interactor = runtime.interactor
            let presenter = runtime.presenter
            let parentId = request.queryString("parent_id")?
                .whitespaceTrimmed
                .emptyToNil
            let view = request.queryString("view") ?? "grid"
            let model = try await interactor.getAddMediaFolder(
                parentId: parentId,
                view: view
            )
            return try await presenter.renderPage(
                model: model
            )
        }

        func postAddMediaFolder(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response {
            let runtime = buildRuntime(request, context)
            let interactor = runtime.interactor
            let presenter = runtime.presenter
            let isDialog = request.queryString("presentation") == "dialog"
            let payload = try await request.decode(
                as: Asset.Folder.Add.Form.Input.self,
                context: context
            )
            let model = try await interactor.postAddMediaFolder(
                payload: payload
            )
            if model.error == nil {
                let notification = AdminNotification.State(
                    title: "Added",
                    message: "Media folder added successfully."
                )
                if isDialog {
                    return Response(
                        status: .noContent,
                        headers: [
                            .setCookie:
                                AdminNotification
                                .cookie(for: notification)
                                .description
                        ]
                    )
                }
                return AdminNotification.redirect(
                    to: redirectLocation(
                        parentId: model.parentId,
                        view: model.view
                    ),
                    notification: notification
                )
            }
            return
                try await presenter.renderPage(
                    model: model
                )
                .response(from: request, context: context)
        }
    }
}

extension Asset.Folder.Add.Controller.Default {
    fileprivate func redirectLocation(
        parentId: String?,
        view: String
    ) -> String {
        var queryItems: [URLQueryItem] = []
        if let parentId, !parentId.isEmpty {
            queryItems.append(.init(name: "parent_id", value: parentId))
        }
        if view != "grid" {
            queryItems.append(.init(name: "view", value: view))
        }
        var components = URLComponents()
        components.path = routes.file.list.path
        components.queryItems = queryItems.isEmpty ? nil : queryItems
        return components.string ?? routes.file.list.path
    }
}
