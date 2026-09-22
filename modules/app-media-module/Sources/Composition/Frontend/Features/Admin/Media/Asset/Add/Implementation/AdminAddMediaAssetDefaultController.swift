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

struct AdminAddMediaAssetDefaultController: AdminAddMediaAssetController {
    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AdminAddMediaAssetInteractor,
            presenter: any AdminAddMediaAssetPresenter
        )

    func getAddMediaAsset(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime(request, context)
        let parentId =
            request.queryString("parent_id")?
            .whitespaceTrimmed
            .emptyToNil ?? ""
        let view = request.queryString("view") ?? "grid"
        let picker = pickerState(request: request)
        var model = try await interactor.getAddMediaAsset()
        model = .init(
            parentId: parentId,
            fileName: "",
            extension: model.extension,
            title: model.title,
            altText: model.altText,
            data: model.data,
            error: model.error,
            view: view,
            action: actionPath(
                parentId: parentId.emptyToNil,
                view: view,
                picker: picker
            ),
            isPicker: picker.isEnabled,
            selectedAsset: nil
        )
        return try await presenter.renderPage(
            model: model
        )
    }

    func postAddMediaAsset(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response {
        let (interactor, presenter) = buildRuntime(request, context)
        let payload = try await request.decode(
            as: AssetAddForm.self,
            context: context
        )
        let picker = pickerState(request: request)
        let model = try await interactor.postAddMediaAsset(payload: payload)
        if model.error == nil {
            if picker.isEnabled, model.selectedAsset != nil {
                let pickerModel = AdminAddMediaAssetModel(
                    parentId: payload.parentId,
                    fileName: "",
                    extension: payload.extension,
                    title: "",
                    altText: "",
                    data: "",
                    error: nil,
                    view: model.view,
                    action: actionPath(
                        parentId: payload.parentId.emptyToNil,
                        view: model.view,
                        picker: picker
                    ),
                    isPicker: true,
                    selectedAsset: model.selectedAsset
                )
                return
                    try await presenter.renderPage(
                        model: pickerModel
                    )
                    .response(from: request, context: context)
            }

            return AdminNotificationFlash.redirect(
                to: redirectLocation(
                    parentId: payload.parentId.emptyToNil,
                    view: model.view
                ),
                notification: .init(
                    title: "Added",
                    message: "Media asset added successfully."
                )
            )
        }

        let errorModel = AdminAddMediaAssetModel(
            parentId: model.parentId,
            fileName: model.fileName,
            extension: model.extension,
            title: model.title,
            altText: model.altText,
            data: model.data,
            error: model.error,
            view: model.view,
            action: actionPath(
                parentId: model.parentId.emptyToNil,
                view: model.view,
                picker: picker
            ),
            isPicker: picker.isEnabled,
            selectedAsset: nil
        )
        return
            try await presenter.renderPage(
                model: errorModel
            )
            .response(from: request, context: context)
    }
}

extension AdminAddMediaAssetDefaultController {
    fileprivate struct PickerState {
        let isEnabled: Bool
        let field: String?
        let allowedExtensions: [String]
        let defaultFolderPath: String?
    }

    fileprivate func pickerState(
        request: Request
    ) -> PickerState {
        .init(
            isEnabled: request.queryString("picker") == "1",
            field: request.queryString("field")?.emptyToNil,
            allowedExtensions: request.queryString("extensions")?
                .split(separator: ",")
                .map {
                    $0.whitespaceTrimmed
                        .lowercased()
                }
                .filter { !$0.isEmpty } ?? [],
            defaultFolderPath: request.queryString("default_folder_path")?
                .emptyToNil
        )
    }

    fileprivate func actionPath(
        parentId: String?,
        view: String,
        picker: PickerState
    ) -> String {
        var queryItems: [String] = []
        if let parentId, !parentId.isEmpty {
            queryItems.append("parent_id=\(parentId.queryEncoded())")
        }
        if view != "grid" {
            queryItems.append("view=\(view.queryEncoded())")
        }
        if picker.isEnabled {
            queryItems.append("picker=1")
        }
        if let field = picker.field {
            queryItems.append("field=\(field.queryEncoded())")
        }
        if !picker.allowedExtensions.isEmpty {
            queryItems.append(
                "extensions=\(picker.allowedExtensions.joined(separator: ",").queryEncoded())"
            )
        }
        if let defaultFolderPath = picker.defaultFolderPath {
            queryItems.append(
                "default_folder_path=\(defaultFolderPath.queryEncoded())"
            )
        }
        return queryItems.isEmpty
            ? "/admin/media/assets/add/"
            : "/admin/media/assets/add/?\(queryItems.joined(separator: "&"))"
    }

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
