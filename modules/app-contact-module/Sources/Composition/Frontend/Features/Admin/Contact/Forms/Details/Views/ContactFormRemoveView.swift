import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct ContactFormRemoveView: Component {
    let id: String
    let name: String
    let breadcrumb: AdminBreadcrumb.State

    func html(context: inout RenderContext) -> some BasicTag {
        context.render(
            AdminConfirmationDialog(
                state: .init(
                    breadcrumb: breadcrumb,
                    title: "Remove contact form",
                    message:
                        "Are you sure you want to remove this form? This action cannot be undone.",
                    details: [.init(prefix: "Name: ", value: name)],
                    submitLabel: "Remove form",
                    actionURL: "/admin/contact/forms/remove/",
                    cancelURL: "/admin/contact/forms/",
                    hiddenFields: [.init(name: "selectedIds[]", value: id)]
                )
            )
        )
    }
}
