import FeatherAdmin
import HTML
import WebBuilders
import WebComponents

struct NewsErrorPage: Component {
    let breadcrumb: [AdminBreadcrumb.Link]
    let title: String
    let message: String

    func html(
        context: inout BuilderContext
    ) -> Section {
        Section {
            context.build(AdminBreadcrumb(links: breadcrumb))
            context.build(
                AdminStatusView(
                    state: .init(title: title, message: message),
                    icon: FeatherIcons.alertCircle()
                )
            )
        }
        .class("cms-section")
    }
}
