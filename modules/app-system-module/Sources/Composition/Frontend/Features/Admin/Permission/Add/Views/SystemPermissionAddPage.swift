import FeatherAdmin
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents

struct SystemPermissionAddPage: Component {
    struct State {
        let form: SystemPermissionAddForm.State
        let nonceToken: String?
    }

    let state: State

    func html(context: inout BuilderContext) -> some BasicTag {
        Section {
            context.build(
                NewAdminBreadcrumb(links: SystemPermissionRoutes.breadcrumb)
            )
            context.build(
                NewAdminPageHeader(
                    state: .init(
                        title: "Add system permission",
                        description: "Create a system permission."
                    )
                )
            )
            context.build(
                SystemPermissionAddForm(
                    state: state.form,
                    action: SystemPermissionRoutes.add.description,
                    nonceToken: state.nonceToken
                )
            )
        }
        .class("cms-section")
    }
}
