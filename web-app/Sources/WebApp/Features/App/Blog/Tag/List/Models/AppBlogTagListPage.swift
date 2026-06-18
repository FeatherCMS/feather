import HTML
import SGML
import WebStandards

struct AppBlogTagListPage: Component, FlowContent {
    let state: AppGetBlogTagListModel

    func content() -> some BasicTag {
        Main {
            AppPublicStyleAnchor()
            Div {
                Div {
                    P("Blog").class("public-eyebrow")
                    H1(state.title)
                    P("Published tags")
                }
                .class("public-heading")

                Div {
                    for item in state.items {
                        A {
                            H2(item.title)
                            if !item.excerpt.isEmpty {
                                P(item.excerpt)
                            }
                        }
                        .href(item.href)
                        .class("public-card")
                    }
                }
                .class("public-grid")
            }
            .class("public-container public-panel")
        }
        .class("public-shell")
    }
}
