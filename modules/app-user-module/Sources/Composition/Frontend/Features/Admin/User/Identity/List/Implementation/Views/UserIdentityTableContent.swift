import FeatherAdmin
import FeatherContracts
import HTML
import Hummingbird
import SGML
import UserAdminAPI
import UserContracts
import WebBuilders
import WebComponents

struct UserIdentityTableContent: Component {
    let permissions: NewAdminListActions
    let identities: [Components.Schemas.UserIdentityListItemSchema]
    let pageState: NewAdminListPageState
    let search: String?
    let role: String?

    func html(context: inout RenderContext) -> Div {
        context.render(NewAdminList(
            table: {
                if pageState.isPageOutOfRange {
                    context.render(NewAdminListInvalidPageState(pageState: pageState, path: UserIdentityRoutes.list.description))
                } else if identities.isEmpty {
                    context.render(NewAdminListEmptyState(message: search?.isEmpty ?? true ? "No user identities yet." : "No user identities match your search.", icon: FeatherIcons.inbox(), action: {
                        if !(search?.isEmpty ?? true) { context.render(NewAdminButton("Reset search", href: UserIdentityRoutes.list.description, style: .secondary)) }
                        else if permissions.allows(UserPermissions.Identities.create) { context.render(NewAdminButton("Add new", href: UserIdentityRoutes.add.description)) }
                    }))
                } else {
                    let canDelete = permissions.allows(UserPermissions.Identities.delete)
                    context.render(NewAdminListSelectionForm(state: .init(action: UserIdentityRoutes.remove.description, pageState: pageState, search: search ?? "", button: .init("Remove selected", style: .destructive), isEnabled: canDelete), table: context.render(NewAdminListShell(table: Table {
                        Thead { Tr {
                            if canDelete { context.render(NewAdminListSelectAllCheckbox()) }
                            Th("Name"); Th("ID"); Th("Status"); Th("Roles"); Th("Actions")
                        }}
                        Tbody { for identity in identities {
                            context.render(UserIdentityRow(identity: identity, permissions: permissions))
                        }}
                    }.class("cms-table", "action-table").if(canDelete) { $0.class("select-table") }))))
                }
            },
            search: { context.render(NewAdminListSearch(state: .init(action: UserIdentityRoutes.list.description, placeholder: "Quick search user identities", search: search ?? ""))) },
            toolbar: {
                if permissions.allows(UserPermissions.Identities.create) { context.render(NewAdminListToolbar { context.render(NewAdminButton("Add new", href: UserIdentityRoutes.add.description)) }) }
            },
            pagination: { context.render(NewAdminListPagination(state: .init(path: UserIdentityRoutes.list.description, pageState: pageState, search: search ?? ""))) }
        ))
    }
}
