import BlogAppAPI
import FeatherValidation
import FeatherWebAdmin
import HTML
import Hummingbird
import MediaWebAdmin
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents
import WebModuleWebApp

struct AppBlogTagPage: Component {
    let state: AppGetBlogTagModel

    func html(context: inout BuilderContext) -> some BasicTag {
        Main {
            context.build(AppPublicStyleAnchor())
            Div {
                Article {
                    Div {
                        P("Tag").class("public-eyebrow")
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

                    if !state.posts.isEmpty {
                        Section {
                            H2("Posts")
                            Div {
                                for post in state.posts {
                                    A {
                                        H3(post.title)
                                        if !post.excerpt.isEmpty {
                                            P(post.excerpt)
                                        }
                                    }
                                    .href(post.href)
                                    .class("public-card")
                                }
                            }
                            .class("public-grid")
                        }
                        .class("public-section")
                    }
                }
                .class("public-panel")
            }
            .class("public-container")
        }
        .class("public-shell")
    }
}
