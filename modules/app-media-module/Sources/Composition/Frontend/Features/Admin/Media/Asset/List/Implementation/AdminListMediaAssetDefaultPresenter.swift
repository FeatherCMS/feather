import FeatherAdmin
import FeatherContracts
import FeatherValidation
import HTML
import Hummingbird
import MediaAdminAPI
import MediaContracts
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminListMediaAssetDefaultPresenter: AdminListMediaAssetPresenter {
    let request: Request
    let context: AuthenticatedRequestContext
    let renderEngine: any RenderingEngine

    func renderListPage(
        model: AdminListMediaAssetModel,
        search: String?,
        permissions: NewAdminListActions
    ) async throws -> HTMLResponse {
        let isDialog = request.queryString("presentation") == "dialog"
            && request.headers[.accept]?.contains("type=admin-dialog") == true
        let content = AssetListView(
            state: .init(
                entries: model.entries,
                pageState: model.pageState,
                search: search ?? "",
                parentId: model.parentId,
                currentFolder: model.currentFolder,
                ancestors: model.ancestors,
                view: model.view,
                picker: model.picker,
                permissions: permissions
            )
        )
        if model.picker.isEnabled && isDialog {
            let navigation = MediaAssetPickerDialogNavigation(
                field: model.picker.field
            )
            return try await renderEngine.renderNewAdminDialog(
                request: request,
                context: context,
                title: "Select media asset",
                content: MediaAssetPickerDialogView(
                    navigation: navigation,
                    content: content
                ),
                size: .large
            )
        }
        if model.picker.isEnabled {
            return try await renderEngine.renderNewAdminPage(
                request: request,
                context: context,
                title: "Select media asset",
                content: content
            )
        }
        return try await renderEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Media assets",
            content: content
        )
    }

    func renderErrorPage(
        message: String,
        picker: Bool
    ) async throws -> HTMLResponse {
        let isDialog = request.queryString("presentation") == "dialog"
            && request.headers[.accept]?.contains("type=admin-dialog") == true
        if picker {
            let errorContent = MediaAssetErrorView(
                info: "Unable to load media assets.",
                message: message
            )
            if isDialog {
                return try await renderEngine.renderNewAdminDialog(
                    request: request,
                    context: context,
                    title: "Select media asset",
                    content: MediaAssetPickerDialogView(
                        navigation: pickerNavigation(),
                        content: errorContent
                    ),
                    size: .large
                )
            }
            return try await renderEngine.renderNewAdminPage(
                request: request,
                context: context,
                title: "Select media asset",
                content: errorContent
            )
        }
        return try await renderEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Media assets",
            content: MediaAssetErrorView(
                info: "Unable to load media assets.",
                message: message
            )
        )
    }

    private func pickerNavigation() -> MediaAssetPickerDialogNavigation {
        MediaAssetPickerDialogNavigation(
            field: request.queryString("field")?.emptyToNil
        )
    }

    func renderRemovePage(
        pageState: NewAdminListPageState,
        search: String?,
        items: [NewAdminRemoveItemContext],
        returnTo: String?
    ) async throws -> HTMLResponse {
        let nonceToken = await AdminNonceStore.shared.issue(
            sessionToken: context.sessionToken
        )
        let cancel = NewAdminLocation.removeCancel(
            path: MediaAssetRoutes.list.description,
            returnTo: returnTo
        )
        let isDialog = request.queryString("presentation") == "dialog"
            && request.headers[.accept]?.contains("type=admin-dialog") == true
        let confirmation = NewAdminRemoveConfirmation(
            breadcrumb: MediaAssetRoutes.breadcrumb,
            pageHeader: .init(
                title: "Remove selected assets",
                description: "Confirm removal of the selected media assets."
            ),
            selectedItems: items.map(\.label),
            action: MediaAssetRoutes.remove.description,
            cancel: cancel,
            submitLabel: "Remove selected",
            nonceToken: nonceToken,
            hiddenFields: items.map {
                .init(name: "ids", value: $0.id)
            } + [
                .init(name: "page", value: String(pageState.page)),
                .init(name: "search", value: search ?? ""),
                .init(name: "returnTo", value: cancel),
            ],
            sectionDescription: isDialog
                ? "Confirm removal of the selected media assets."
                : nil,
            isDialog: isDialog
        )
        if isDialog {
            return try await renderEngine.renderNewAdminDialog(
                request: request,
                context: context,
                title: "Remove selected assets",
                content: confirmation,
                size: .small
            )
        }
        return try await renderEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Remove selected assets",
            content: confirmation
        )
    }

    func renderInvalidNoncePage(
        cancel: String
    ) async throws -> HTMLResponse {
        let page = try await renderEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Remove media assets",
            content: NewAdminStatusView(
                state: .init(
                    title: "Confirmation expired",
                    message:
                        "This confirmation is no longer valid. Please try again."
                ),
                icon: FeatherIcons.alertCircle(),
                action: NewAdminButton("Back", href: cancel, style: .secondary)
            )
        )
        return HTMLResponse(content: page.content, status: .badRequest)
    }
}
