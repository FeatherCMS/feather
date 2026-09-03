import FeatherAdmin
import FeatherContracts
import HTML
import Hummingbird
import UserContracts

struct AdminListUserIdentityDefaultController: AdminListUserIdentityController {
    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AdminListUserIdentityInteractor,
            presenter: any AdminListUserIdentityPresenter
        )

    func getUserIdentities(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime(request, context)
        let permissionSet = context.currentUserPermissions
        let permissions = UserPermissions.Identities.list
        let canAccess = context.isCurrentUserAllowed(
            to: permissions
        )
        let page = request.queryPage()
        let pageSize = 20
        let search = request.querySearch()
        let role = request.uri.queryParameters["role"].map(String.init)

        do {
            let result =
                canAccess
                ? try await interactor.execute(
                    page: page,
                    size: pageSize,
                    search: search,
                    role: role
                )
                : (
                    items: [],
                    total: 0,
                    page: page,
                    size: pageSize
                )
            let roleOptions =
                canAccess
                ? try await interactor.listRoles()
                : []

            let state = UserIdentityTable.State(
                isAdded: request.hasQueryFlag("added"),
                isEdited: request.hasQueryFlag("edited"),
                isRemoved: request.hasQueryFlag("removed"),
                canAccess: canAccess,
                permissions: permissionSet,
                canAdd: permissionSet.contains(
                    UserPermissions.Identities.create.rawValue
                ),
                identities: result.items,
                page: result.page,
                pageSize: result.size,
                total: result.total,
                search: search ?? "",
                role: role ?? "",
                roleOptions: roleOptions,
                deniedInfo: "Forbidden",
                deniedMessage:
                    "Your identity cannot access user identities.",
                breadcrumb: .init(
                    links: [
                        .init(label: "Admin", link: "/admin/"),
                        .init(label: "User", link: "/admin/user/"),
                        .init(
                            label: "Identities",
                            link: "/admin/user/identities/"
                        ),
                    ]
                )
            )
            return presenter.renderPage(state: state)
        }
        catch let error as OpenAPIRepositoryError {
            return presenter.renderError(error: error)
        }
    }

    func getUserIdentitiesRemoveConfirmation(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response {
        let (_, presenter) = buildRuntime(request, context)
        let selectedIds = request.queryStrings("selectedIds")
        let page = request.queryPage()
        let search = request.querySearch()
        let role = request.uri.queryParameters["role"].map(String.init)
        guard !selectedIds.isEmpty else {
            return Response(
                status: .seeOther,
                headers: [
                    .location: ListRemoveRedirect.location(
                        path: "/admin/user/identities/",
                        page: page,
                        search: search,
                        queryItems: role.map { [("role", $0)] } ?? [],
                        title: nil,
                        message: nil
                    )
                ]
            )
        }
        return
            try presenter.renderRemoveConfirmation(
                selectedIds: selectedIds,
                page: page,
                search: search,
                role: role,
                permissions: context.currentUserPermissions
            )
            .response(from: request, context: context)
    }

    func postUserIdentitiesRemove(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response {
        let (interactor, _) = buildRuntime(request, context)
        let payload = try await request.decode(
            as: ListRemoveFormInput.self,
            context: context
        )
        let role = request.uri.queryParameters["role"].map(String.init)
        if !payload.normalizedSelectedIds.isEmpty {
            try await interactor.remove(ids: payload.normalizedSelectedIds)
        }
        return Response(
            status: .seeOther,
            headers: [
                .location: ListRemoveRedirect.location(
                    path: "/admin/user/identities/",
                    page: payload.normalizedPage,
                    search: payload.normalizedSearch,
                    queryItems: role.map { [("role", $0)] } ?? [],
                    title: !payload.normalizedSelectedIds.isEmpty
                        ? "Removed" : nil,
                    message: !payload.normalizedSelectedIds.isEmpty
                        ? "User identity removed successfully." : nil
                )
            ]
        )
    }
}
