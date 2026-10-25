import AccountModule
import FeatherWebAdmin
import HTML
import SGML
import WebBuilders
import WebComponents

extension Invitation.Edit {
    struct Page: Component {
        let routes: Invitation.Router.Routes

        struct State {
            let id: String
            let isEdited: Bool
            let form: Invitation.Form.Component.State
            let breadcrumb: [AdminBreadcrumb.Link]
        }

        let state: State

        func html(context: inout BuilderContext) -> some BasicTag {
            Section {
                context.build(AdminBreadcrumb(links: state.breadcrumb))
                context.build(
                    AdminPageHeader(
                        state: .primary(
                            title: "Edit user invitation",
                            description:
                                "Update the invited user and assigned roles."
                        )
                    )
                )
                if state.isEdited { P("User invitation edited successfully.") }
                context.build(
                    Invitation.Form.Component(
                        state: state.form,
                        action: routes.invitationEditPath(state.id) + "/",
                        submitLabel: "Edit invitation",
                        removeHref: routes.invitationRemovePath(state.id) + "/",
                        removeLabel: "Remove invitation"
                    )
                )
            }
            .class("cms-section")
        }
    }
}
