import FeatherAdmin
import HTML
import SGML
import WebBuilders
import WebComponents

struct AuthSessionError: Component {

    struct State {
        let info: String
        let message: String
        let breadcrumb: [NewAdminBreadcrumb.Link]
    }

    let state: State

    func html(context: inout BuilderContext) -> some BasicTag {
        context.build(
            NewAdminStatusView(
                state: .init(title: state.info, message: state.message),
                icon: FeatherIcons.alertCircle()
            )
        )
    }
}
