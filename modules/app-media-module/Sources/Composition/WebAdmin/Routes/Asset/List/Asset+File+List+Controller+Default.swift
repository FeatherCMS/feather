import FeatherModuleKit
import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import MediaAdminAPI
import MediaModule
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

extension Asset.File.List.Controller {
    struct Default: Asset.File.List.Controller.Interface {
        private static let viewCookieName = "admin_media_assets_view"

        let buildRuntime:
            @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
                any Asset.File.List.Interactor.Interface,
                any Asset.File.List.Presenter.Interface
            >
        let routes: Asset.Router.Routes

        func getListMediaAssets(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse {
            let __runtimeBuild1 = buildRuntime(request, context)
            let interactor = __runtimeBuild1.interactor
            let presenter = __runtimeBuild1.presenter
            let page = request.queryPage()
            let search = request.querySearch()
            let parentId = request.queryString("parent_id")?
                .whitespaceTrimmed
                .emptyToNil
            let requestedView = request.queryString("view")
                .flatMap(Asset.File.List.Model.ViewMode.init(rawValue:))
            let storedView = request.cookies[Self.viewCookieName]
                .flatMap {
                    Asset.File.List.Model.ViewMode(rawValue: $0.value)
                }
            let view = requestedView ?? storedView ?? .grid
            let isPicker = request.queryString("picker") == "1"
            let picker = Asset.File.List.Model.PickerState(
                isEnabled: isPicker,
                configuration: isPicker
                    ? .init(
                        field: request.queryString("field")?.emptyToNil ?? "",
                        selectionMode: request.queryString("selection")
                            == "multiple"
                            ? .multiple
                            : .single,
                        allowedExtensions: .custom(
                            request.queryString("extensions")?
                                .split(separator: ",")
                                .map(String.init) ?? []
                        ),
                        defaultFolderPath: request.queryString(
                            "default_folder_path"
                        )?
                        .emptyToNil,
                        previewVariant: request.queryString("preview_variant")?
                            .emptyToNil
                    )
                    : nil,
                resetSelection: request.queryString("selection_reset") == "1"
            )
            let permissions = context.currentUserAdminListActions
            guard permissions.allows(Asset.Permissions.list) else {
                return try await presenter.renderErrorPage(
                    message: "Your account cannot access media assets.",
                    picker: picker.isEnabled
                )
            }
            do {
                let model = try await interactor.listMediaAssets(
                    page: page,
                    search: search,
                    parentId: parentId,
                    view: view,
                    picker: picker
                )
                let page = try await presenter.renderListPage(
                    model: model,
                    search: search,
                    permissions: permissions
                )
                guard let requestedView else {
                    return page
                }
                return HTMLResponse(
                    content: page.content,
                    status: page.status,
                    cookies: [
                        Cookie(
                            name: Self.viewCookieName,
                            value: requestedView.rawValue,
                            maxAge: 60 * 60 * 24 * 365,
                            path: routes.file.list.path,
                            httpOnly: false,
                            sameSite: .lax
                        )
                    ]
                )
            }
            catch let caughtError {
                return try await presenter.renderErrorPage(
                    message: caughtError.displayMessage,
                    picker: picker.isEnabled
                )
            }
        }
    }
    }

    extension Asset.File.List.Controller.Default {
    fileprivate func redirectLocation(
        request: Request
    ) -> String {
        AdminLocation.removeCancel(
            path: routes.file.list.path,
            returnTo: request.queryString("returnTo")
        )
    }
}
