import FeatherAdmin
import FeatherContracts
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import HTTPTypes
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminAddMediaAssetDefaultController: AdminAddMediaAssetController {
    let buildRuntime:
        AuthenticatedRuntimeBuilder<
            any AdminAddMediaAssetInteractor,
            any AdminAddMediaAssetPresenter
        >

    func getAddMediaAsset(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime((request, context))
        let parentId =
            request.queryString("parent_id")?
            .whitespaceTrimmed
            .emptyToNil ?? ""
        let view = request.queryString("view") ?? "grid"
        let picker = pickerState(request: request)
        let isDialog = request.queryString("presentation") == "dialog"
            && request.headers[.accept]?.contains("type=admin-dialog") == true
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
                picker: picker,
                isDialog: isDialog
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
        context: AuthenticatedRequestContext
    ) async throws -> Response {
        let (interactor, presenter) = buildRuntime((request, context))
        let isDialog = request.queryString("presentation") == "dialog"
            && request.headers[.accept]?.contains("type=admin-dialog") == true
        let picker = pickerState(request: request)
        guard
            let fileName = header(
                "X-Media-Asset-File-Name",
                from: request
            )?.whitespaceTrimmed,
            !fileName.isEmpty,
            let fileExtension = header(
                "X-Media-Asset-Extension",
                from: request
            )?.whitespaceTrimmed,
            !fileExtension.isEmpty,
            let rawLength = request.headers[.contentLength],
            let contentLength = Int64(rawLength),
            contentLength > 0
        else {
            throw HTTPError(.badRequest)
        }
        if picker.isEnabled,
           !picker.allowedExtensions.isAnything,
           !picker.allowedExtensions.values.contains(fileExtension.lowercased())
        {
            let parentId = header("X-Media-Asset-Parent-ID", from: request) ?? ""
            let view = request.queryString("view") ?? "grid"
            let errorModel = AdminAddMediaAssetModel(
                parentId: parentId,
                fileName: fileName,
                extension: fileExtension,
                title: defaultTitle(for: fileName),
                altText: "",
                data: "",
                error:
                    "Please choose a file with one of these extensions: "
                    + picker.allowedExtensions.queryValue,
                view: view,
                action: actionPath(
                    parentId: parentId.emptyToNil,
                    view: view,
                    picker: picker,
                    isDialog: isDialog
                ),
                isPicker: true,
                selectedAsset: nil
            )
            return try await presenter.renderPage(
                model: errorModel
            )
            .response(from: request, context: context)
        }
        let payload = AssetAddUpload(
            parentId: header("X-Media-Asset-Parent-ID", from: request) ?? "",
            fileName: fileName,
            extension: fileExtension,
            title: header("X-Media-Asset-Title", from: request)?
                .whitespaceTrimmed
                .emptyToNil ?? defaultTitle(for: fileName),
            altText: header("X-Media-Asset-Alt-Text", from: request) ?? "",
            view: request.queryString("view") ?? "grid",
            content: .init(
                MediaHTTPBodySequence(body: request.body),
                length: .known(contentLength),
                iterationBehavior: .single
            )
        )
        let model = try await interactor.postAddMediaAsset(
            payload: payload,
            variants: picker.previewVariant.map { [$0, "preview"] }
        )
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
                        picker: picker,
                        isDialog: isDialog
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

            if isDialog {
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
                picker: picker,
                isDialog: isDialog
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
    fileprivate func defaultTitle(for fileName: String) -> String {
        URL(fileURLWithPath: fileName)
            .deletingPathExtension()
            .lastPathComponent
    }

    fileprivate func header(_ name: String, from request: Request) -> String? {
        guard let fieldName = HTTPField.Name(name) else { return nil }
        guard let value = request.headers[fieldName] else { return nil }
        return value.removingPercentEncoding ?? value
    }

    fileprivate struct PickerState {
        let isEnabled: Bool
        let field: String?
        let allowedExtensions: AllowedExtensions
        let defaultFolderPath: String?
        let previewVariant: String?
    }

    fileprivate func pickerState(
        request: Request
    ) -> PickerState {
        .init(
            isEnabled: request.queryString("picker") == "1",
            field: request.queryString("field")?.emptyToNil,
            allowedExtensions: .custom(
                request.queryString("extensions")?
                    .split(separator: ",")
                    .map(String.init) ?? []
            ),
            defaultFolderPath: request.queryString("default_folder_path")?
                .emptyToNil,
            previewVariant: request.queryString("preview_variant")?
                .emptyToNil
        )
    }

    fileprivate func actionPath(
        parentId: String?,
        view: String,
        picker: PickerState,
        isDialog: Bool = false
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
        if !picker.allowedExtensions.isAnything {
            queryItems.append(
                "extensions=\(picker.allowedExtensions.queryValue.queryEncoded())"
            )
        }
        if let defaultFolderPath = picker.defaultFolderPath {
            queryItems.append(
                "default_folder_path=\(defaultFolderPath.queryEncoded())"
            )
        }
        if let previewVariant = picker.previewVariant {
            queryItems.append(
                "preview_variant=\(previewVariant.queryEncoded())"
            )
        }
        if isDialog {
            queryItems.append("presentation=dialog")
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
