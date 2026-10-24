import AuthModule
import FeatherWebAdmin
import HTML
import SGML
import WebBuilders
import WebComponents

extension Session.Remove {
    struct Error: Component {

        struct State {
            let info: String
            let message: String
            let breadcrumb: [AdminBreadcrumb.Link]
        }

        let state: State

        func html(context: inout BuilderContext) -> some BasicTag {
            context.build(
                AdminStatusView(
                    state: .init(title: state.info, message: state.message),
                    icon: FeatherIcons.alertCircle()
                )
            )
        }
    }
}
