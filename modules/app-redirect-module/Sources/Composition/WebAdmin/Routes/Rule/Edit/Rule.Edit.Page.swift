import FeatherWebAdmin
import HTML
import Hummingbird
import RedirectApplication
import RedirectModule
import WebBuilders
import WebComponents

extension Rule.Edit {
    struct Page: Component {
        let id: String
        let form: RedirectModule.Rule.Edit.Form.State
        let nonceToken: String
        let permissions: AdminListActions
        let routes: Rule.Router.Routes

        func html(context: inout BuilderContext) -> Section {
            Section {
                context.build(
                    AdminBreadcrumb(links: routes.breadcrumb)
                )
                context.build(
                    AdminPageHeader(
                        state: .primary(
                            title: "Edit redirect rule",
                            description:
                                "Update the redirect rule configuration."
                        )
                    )
                )
                context.build(
                    RedirectModule.Rule.Edit.Form(
                        state: form,
                        action: routes.editPath(id),
                        viewHref: permissions.allows(Rule.Permissions.read)
                            ? routes.detailsPath(id)
                            : nil,
                        removeHref: permissions.allows(
                            Rule.Permissions.delete
                        )
                            ? routes.removePath(id)
                            : nil,
                        nonceToken: nonceToken
                    )
                )
            }
            .class("cms-section")
        }
    }
}
