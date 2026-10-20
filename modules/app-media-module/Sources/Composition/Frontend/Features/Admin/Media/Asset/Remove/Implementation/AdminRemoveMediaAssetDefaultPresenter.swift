import FeatherWebAdmin
import FeatherValidation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminRemoveMediaAssetDefaultPresenter: AdminRemoveMediaAssetPresenter {
    let request: Request
    let context: AuthenticatedRequestContext
    let renderEngine: any RenderingEngine

    func renderRemovePage(
        model: AdminRemoveMediaAssetModel
    ) async throws -> HTMLResponse {
        let nonceToken = await AdminNonceStore.shared.issue(
            sessionToken: context.sessionToken
        )
        return try await renderEngine.renderAdminDialog(
            request: request,
            context: context,
            title: AdminRemoveConfirmation.dialogTitle,
            content: AssetRemoveView(
                item: model.item,
                nonceToken: nonceToken
            ),
            size: .small
        )
    }
}
