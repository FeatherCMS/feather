import FeatherModuleKit
import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import HTML
import HTTPTypes
import Hummingbird
import MediaAdminAPI
import MediaModule
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

extension Asset.File.Add.Presenter {
    struct Default: Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderEngine: any RenderingEngine
        let routes: Asset.Router.Routes

        func renderPage(
            model: Asset.File.Add.Model
        ) async throws -> HTMLResponse {
            let isDialog =
                request.queryString("presentation") == "dialog"
                && request.headers[.accept]?.contains("type=admin-dialog")
                    == true
            let content = MediaAssetUploadView(
                state: .init(
                    routes: routes,
                    form: .init(
                        parentId: model.parentId,
                        fileName: model.fileName,
                        extension: model.extension,
                        title: model.title,
                        altText: model.altText,
                        data: model.data,
                        error: model.error,
                        view: model.view,
                        action: model.action,
                        isPicker: model.isPicker,
                        pickerField: request.queryString("field")?.emptyToNil,
                        allowedExtensions: pickerExtensions(),
                        isDialog: isDialog,
                        previewVariant: request.queryString("preview_variant")?
                            .emptyToNil,
                        selectedAsset: model.selectedAsset,
                        selectionMode: request.queryString("selection")
                            == "multiple"
                            ? .multiple
                            : .single
                    )
                )
            )
            if isDialog {
                return try await renderEngine.renderAdminDialog(
                    request: request,
                    context: context,
                    title: model.isPicker
                        ? "Upload media assets" : "Add media asset",
                    content: content,
                    size: .small
                )
            }
            if model.isPicker {
                return renderEngine.renderAdminStandalonePage(
                    title: "Upload media asset",
                    content: content
                )
            }
            return try await renderEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Add media asset",
                content: content
            )
        }

        private func pickerExtensions() -> AllowedExtensions {
            .custom(
                request.queryString("extensions")?
                    .split(separator: ",")
                    .map(String.init) ?? []
            )
        }

    }
}
