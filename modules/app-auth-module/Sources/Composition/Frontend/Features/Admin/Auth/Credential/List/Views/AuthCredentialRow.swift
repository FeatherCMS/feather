import AuthAdminAPI
import AuthContracts
import FeatherAdmin
import FeatherContracts
import HTML
import SGML
import WebBuilders
import WebComponents

struct AuthCredentialRow: Component {
    let credential: AuthAdminAPI.Components.Schemas.AuthCredentialListItemSchema
    let actions: NewAdminListActions

    func html(context: inout BuilderContext) -> Tr {
        Tr {
            Td(credential.identityName).data("label", "User")
            Td(credential.email.emptyToNil ?? "—").data("label", "Email")
            context.build(
                NewAdminListRowActions(
                    label: "Actions",
                    actions: [
                        .init(
                            "Edit",
                            href:
                                "/admin/auth/credentials/\(credential.id)/edit/",
                            style: .ghost(.secondary),
                            permission: AuthPermissions.Credential.update
                        ),
                        .init(
                            "Remove",
                            href:
                                "/admin/auth/credentials/\(credential.id)/remove/",
                            style: .destructive,
                            permission: AuthPermissions.Credential.delete
                        ),
                    ],
                    permissions: actions
                )
            )
        }
    }
}
