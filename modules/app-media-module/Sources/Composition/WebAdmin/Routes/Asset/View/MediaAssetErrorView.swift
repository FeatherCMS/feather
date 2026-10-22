import FeatherValidation
import FeatherWebAdmin
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct MediaAssetErrorView: Component {
    let info: String
    let message: String

    func html(context: inout BuilderContext) -> some BasicTag {
        context.build(
            AdminStatusView(
                state: .init(title: info, message: message),
                icon: FeatherIcons.alertCircle()
            )
        )
    }
}
