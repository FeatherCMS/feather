import FeatherAdmin
import HTML
import SGML
import WebBuilders
import WebComponents

struct AccountProfileEdit: Component {

    struct State {
        let id: String
        let isEdited: Bool
        var form: AccountProfileForm.State
        let breadcrumb: [AdminBreadcrumb.Link]
    }

    let state: State

    func html(context: inout BuilderContext) -> some BasicTag {
        Section {
            context.build(AdminBreadcrumb(links: state.breadcrumb))

            context.build(
                AdminPageHeader(
                    state: .primary(
                        title: "Edit profile",
                        description: "Update the current administrator profile."
                    )
                )
            )
            if state.isEdited {
                P("Profile edited successfully.").class("success")
            }

            context.build(
                AccountProfileForm(
                    state: state.form,
                    action: "/admin/account/profile/edit/",
                    submitLabel: "Save changes"
                )
            )
        }
        .class("cms-section")
    }
}
