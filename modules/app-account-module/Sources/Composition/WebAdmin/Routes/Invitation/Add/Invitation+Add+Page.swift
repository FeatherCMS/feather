import AccountModule
import FeatherWebAdmin
import FeatherWebShared
import HTML
import SGML
import WebBuilders
import WebComponents

extension Invitation.Add {
    struct Page: Component {
        let routes: Invitation.Router.Routes

        struct State {
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
                            title: "Add user invitation",
                            description:
                                "Invite a user and assign their initial roles."
                        )
                    )
                )
                context.build(
                    Invitation.Form.Component(
                        state: state.form,
                        action: routes.invitationAdd.path + "/",
                        submitLabel: "Add invitation"
                    )
                )
            }
            .class("cms-section")
        }
    }
}
