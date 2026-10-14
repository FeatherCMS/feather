public import HTML
import SGML
import WebBuilders
public import WebComponents

public struct AdminListInvalidPageState: Component {

    public let pageState: AdminListPageState
    public let path: String

    public init(
        pageState: AdminListPageState,
        path: String
    ) {
        self.pageState = pageState
        self.path = path
    }

    public func html(context: inout BuilderContext) -> Div {
        context.build(
            AdminListEmptyState(
                message: "Page \(pageState.page) does not exist.",
                icon: FeatherIcons.alertCircle(),
                action: {
                    context.build(
                        AdminButton(
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
