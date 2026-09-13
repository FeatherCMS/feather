import FeatherAdmin
import HTML
import Hummingbird
import WebBuilders
import WebComponents

struct RedirectRuleAddPage: Component {
    let form: RedirectRuleForm.State
    let nonceToken: String

    func html(context: inout RenderContext) -> Section {
        Section {
            context.render(NewAdminBreadcrumb(links: RedirectRuleRoutes.breadcrumb))
            context.render(NewAdminPageHeader(state: .init(title: "Add redirect rule", description: "Create a redirect from one path to another.")))
            context.render(RedirectRuleForm(state: form, action: RedirectRuleRoutes.add.description, submitLabel: "Add rule", viewHref: nil, removeHref: nil, nonceToken: nonceToken))
        }.class("cms-section")
    }
}
