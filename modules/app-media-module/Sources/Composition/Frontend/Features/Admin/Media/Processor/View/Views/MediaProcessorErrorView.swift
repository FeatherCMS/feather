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

    func html(context: inout BuilderContext) -> some BasicTag {
        context.build(
            NewAdminStatusView(
                state: .init(title: "Media processor error", message: info),
                icon: FeatherIcons.alertCircle()
            )
        )
    }
}
