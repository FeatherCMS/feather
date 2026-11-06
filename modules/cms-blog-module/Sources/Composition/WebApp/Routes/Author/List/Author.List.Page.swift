import BlogAppAPI
import BlogModule
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents
import WebModuleWebApp

extension Author.List {
    struct Page: Component {
        let state: Model

        func html(context: inout BuilderContext) -> some BasicTag {
            Main {
                context.build(PublicContent.StyleAnchor())
                Div {
                    Div {
                        P("Blog").class("public-eyebrow")
                        H1(state.title)
                        P("Published authors")
                    }
                    .class("public-heading")

                    Div {
                        for item in state.items {
                            A {
                                H2(item.name)
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
}
