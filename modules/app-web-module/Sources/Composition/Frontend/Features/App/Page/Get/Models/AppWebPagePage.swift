import FeatherAdmin
import HTML
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AppWebPagePage: Component {
    let state: AppGetWebPageModel

    func html(context: inout BuilderContext) -> Main {
        Main {
            context.build(AppPublicStyleAnchor())
            Div {
                Article {
                    Div {
                        P("Page").class("public-eyebrow")
                        H1(state.title)
                        if !state.excerpt.isEmpty {
                            P(state.excerpt)
                        }
                    }
                    .class("public-heading")

                    if let imageURL = state.imageURL {
                        Div {
                            Img(src: imageURL, alt: state.title)
                        }
                        .class("public-image")
                    }

                    context.build(AppPublicTextBlock(text: state.content))
                }
                .class("public-panel")
            }
            .class("public-container")
        }
        .class("public-shell")
    }
}
