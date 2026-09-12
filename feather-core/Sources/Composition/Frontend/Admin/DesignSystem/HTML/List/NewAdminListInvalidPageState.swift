import HTML
import SGML
import WebBuilders
import WebComponents

public struct NewAdminListInvalidPageState: Component {

    public let pageState: NewAdminListPageState
    public let path: String

    public init(
        pageState: NewAdminListPageState,
        path: String
    ) {
        self.pageState = pageState
        self.path = path
    }

    public func html(context: inout RenderContext) -> Div {
        context.render(
            NewAdminListEmptyState(
                message: "Page \(pageState.page) does not exist.",
                icon: FeatherIcons.alertCircle(),
                action: {
                    context.render(
                        NewAdminButton(
                            "Back to list",
                            href: path,
                            style: .secondary
                        )
                    )
                }
            )
        )
    }

}
