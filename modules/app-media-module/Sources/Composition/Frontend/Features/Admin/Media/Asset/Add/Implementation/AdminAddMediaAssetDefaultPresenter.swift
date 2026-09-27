import FeatherAdmin
import FeatherContracts
import FeatherValidation
import HTML
import Hummingbird
import HTTPTypes
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminAddMediaAssetDefaultPresenter: AdminAddMediaAssetPresenter {
    let request: Request
    let context: AuthenticatedRequestContext
    let renderEngine: any RenderingEngine

    func renderPage(
        model: AdminAddMediaAssetModel
    ) async throws -> HTMLResponse {
        var buildContext = BuilderContext()
        let isDialog = request.queryString("presentation") == "dialog"
            && request.headers[.accept]?.contains("type=admin-dialog") == true
        let content = AssetAddView(
            state: .init(
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
                    selectedAsset: model.selectedAsset
                )
            )
        )
        if isDialog {
            return try await renderEngine.renderNewAdminDialog(
                request: request,
                context: context,
                title: model.isPicker ? "Upload media assets" : "Add media asset",
                content: content,
                size: .small
            )
        }
        if model.isPicker {
            return renderEngine.renderPublicPage(
                request: request,
                title: "Upload media asset",
                description: "Upload media asset",
                imagePath: "images/logos/logo.png",
                content: Div {
                    buildContext.build(content)
                }
            )
        }
        return try await renderEngine.renderNewAdminPage(
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
