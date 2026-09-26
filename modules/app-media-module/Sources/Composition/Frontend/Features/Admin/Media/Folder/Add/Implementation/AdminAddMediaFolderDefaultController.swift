import FeatherAdmin
import FeatherContracts
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminAddMediaFolderDefaultController: AdminAddMediaFolderController {
    let buildRuntime:
        AuthenticatedRuntimeBuilder<
            any AdminAddMediaFolderInteractor,
            any AdminAddMediaFolderPresenter
        >

    func getAddMediaFolder(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime((request, context))
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
        let (interactor, presenter) = buildRuntime((request, context))
        let isDialog = request.queryString("presentation") == "dialog"
        let payload = try await request.decode(
            as: MediaFolderAddForm.self,
            context: context
        )
        let model = try await interactor.postAddMediaFolder(payload: payload)
        if model.error == nil {
            let notification = NewAdminNotification.State(
                title: "Added",
                message: "Media folder added successfully."
            )
            if isDialog {
                return Response(
                    status: .noContent,
                    headers: [
                        .setCookie: AdminNotificationFlash
                            .cookie(for: notification)
                            .description
                    ]
                )
            }
            return AdminNotificationFlash.redirect(
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

extension AdminAddMediaFolderDefaultController {
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
        components.path = MediaAssetRoutes.list.description
        components.queryItems = queryItems.isEmpty ? nil : queryItems
        return components.string ?? MediaAssetRoutes.list.description
    }
}
