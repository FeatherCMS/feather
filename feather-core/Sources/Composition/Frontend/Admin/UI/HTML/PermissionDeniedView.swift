import HTML
import SGML
import WebComponents
import WebBuilders

public struct PermissionDeniedView: Leaf {

    public struct State: Sendable {
        public let info: String
        public let message: String
        public let breadcrumb: AdminBreadcrumb.State

        public init(
            info: String,
            message: String,
            breadcrumb: AdminBreadcrumb.State
        ) {
            self.info = info
            self.message = message
            self.breadcrumb = breadcrumb
        }
    }

    public let state: State

    public init(state: State) {
        self.state = state
    }

    public func html() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb).html()

            H1("No permission")
            P(state.info).class("error")
            P(state.message)
        }
        .class("cms-section")
    }
}
