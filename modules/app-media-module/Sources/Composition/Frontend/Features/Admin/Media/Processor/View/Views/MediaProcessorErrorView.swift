import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct MediaProcessorErrorView: Component {
    let info: String

    func html(context: inout RenderContext) -> some BasicTag {
        context.render(
            NewAdminStatusView(
                state: .init(title: "Media processor error", message: info),
                icon: FeatherIcons.alertCircle()
            )
        )
    }
}
