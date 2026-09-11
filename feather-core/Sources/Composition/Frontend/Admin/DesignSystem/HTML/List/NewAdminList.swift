import HTML
import CSS
import SGML
import WebComponents
import WebBuilders

public struct NewAdminList: Leaf {

    public func rules(
    ) -> [any Rule] {
        Media {
            Class("admin-list") {
                Display(.flex)
                FlexDirection(.column)
                Gap(12.px)
            }
            Custom(".admin-list .table-remove-form") {
                Width(100.percent)
            }
            Custom(".admin-list .table-actions") {
                Display(.flex)
                AlignItems(.center)
                JustifyContent(.flexStart)
                Gap(8.px)
                FlexWrap(.wrap)
                MarginTop(10.px)
            }
        }
    }

    public let search: [any FlowContent]
    public let toolbar: [any FlowContent]
    public let table: [any FlowContent]
    public let pagination: [any FlowContent]

    public init(
        @Builder<FlowContent> table: () -> [any FlowContent],
        @Builder<FlowContent> search: () -> [any FlowContent] = { [] },
        @Builder<FlowContent> toolbar: () -> [any FlowContent] = { [] },
        @Builder<FlowContent> pagination: () -> [any FlowContent] = { [] }
    ) {
        self.search = search()
        self.toolbar = toolbar()
        self.table = table()
        self.pagination = pagination()
    }

    public func html(
    ) -> Div {
        Div {
            for item in search {
                item
            }
            for item in toolbar {
                item
            }
            for item in table {
                item
            }
            for item in pagination {
                item
            }
        }
        .class("admin-list")
    }
}
