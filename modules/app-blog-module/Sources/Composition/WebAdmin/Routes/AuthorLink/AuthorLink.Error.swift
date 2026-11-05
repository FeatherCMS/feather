import BlogAdminAPI
import BlogAppAPI
import BlogModule
import FeatherValidation
import FeatherWebAdmin
import HTML
import Hummingbird
import MediaWebAdmin
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents
import WebModuleWebAdmin

extension AuthorLink {
    struct Error: Component {

        struct State {
            let info: String
            let message: String
            let breadcrumb: [AdminBreadcrumb.Link]
        }

        let state: State

        func html(context: inout BuilderContext) -> some BasicTag {
            Section {
                context.build(AdminBreadcrumb(links: state.breadcrumb))
                context.build(
                    AdminStatusView(
                        state: .init(title: state.info, message: state.message),
                        icon: FeatherIcons.alertCircle()
                    )
                )
            }
            .class("cms-section")
        }
    }
}
