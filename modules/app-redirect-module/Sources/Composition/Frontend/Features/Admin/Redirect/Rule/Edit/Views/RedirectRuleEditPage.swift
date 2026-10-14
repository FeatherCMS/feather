import FeatherAdmin
import HTML
import Hummingbird
import RedirectContracts
import WebBuilders
import WebComponents

struct RedirectRuleEditPage: Component {
    let id: String
    let form: RedirectRuleEditForm.State
    let nonceToken: String
    let permissions: AdminListActions

    func html(context: inout BuilderContext) -> Section {
        Section {
            context.build(
                AdminBreadcrumb(links: RedirectRuleRoutes.breadcrumb)
            )
            context.build(
                AdminPageHeader(
                    state: .primary(
                        title: "Edit redirect rule",
                        description: "Update the redirect rule configuration."
                    )
                )
            )
            context.build(
                RedirectRuleEditForm(
                    state: form,
                    action: RedirectRuleRoutes.edit(RouterPath(id)).description,
                    viewHref: permissions.allows(RedirectPermissions.Rules.read)
                        ? RedirectRuleRoutes.details(RouterPath(id)).description
                        : nil,
                    removeHref: permissions.allows(
                        RedirectPermissions.Rules.delete
                    )
                        ? RedirectRuleRoutes.remove(RouterPath(id)).description
                        : nil,
                    nonceToken: nonceToken
                )
            )
        }
        .class("cms-section")
    }
}
