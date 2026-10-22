import BlogAppAPI
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents
import WebModuleWebApp

struct AppBlogAuthorListPage: Component {
    let state: AppGetBlogAuthorListModel

    func html(context: inout BuilderContext) -> some BasicTag {
        Main {
            context.build(AppPublicStyleAnchor())
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
