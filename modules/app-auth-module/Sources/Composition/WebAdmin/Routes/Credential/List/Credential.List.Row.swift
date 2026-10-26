import AuthAdminAPI
import AuthModule
import FeatherModuleKit
import FeatherWebAdmin
import HTML
import SGML
import WebBuilders
import WebComponents

extension Credential.List {
    struct Row: WebComponents.Component {
        let credential:
            AuthAdminAPI.Components.Schemas.AuthCredentialQueryItemSchema
        let actions: AdminListActions
        let routes: Credential.Router.Routes

        func html(context: inout BuilderContext) -> Tr {
            Tr {
                Td(credential.identityName).data("label", "User")
                Td(credential.email.emptyToNil ?? "—").data("label", "Email")
                context.build(
                    AdminListRowActions(
                        label: "Actions",
                        actions: [
                            .init(
                                "Edit",
                                href: routes.editPath(credential.id),
                                style: .ghost(.secondary),
                                permission: Credential.Permissions.update
                            )
                        ],
                        permissions: actions
                    )
                )
            }
        }
    }
}
