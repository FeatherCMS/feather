import HTML
import SGML
import WebStandards

struct AppBlogPostPage: Component, FlowContent {
    let state: AppGetBlogPostModel

    func content() -> some BasicTag {
        Main {
            AppPublicStyleAnchor()
            Div {
                articlePanel()
            }
            .class("public-container")
        }
        .class("public-shell")
    }
}

extension AppBlogPostPage {
    fileprivate func articlePanel() -> some BasicTag {
        Article {
            Div {
                P("Post").class("public-eyebrow")
                H1(state.title)
                if !state.excerpt.isEmpty {
                    P(state.excerpt)
                }
            }
            .class("public-heading")

            if let publishedAt = state.publishedAt {
                Div {
                    Span(publishedAt)
                }
                .class("public-meta")
            }

            if let imageURL = state.imageURL {
                Div {
                    Img(src: imageURL, alt: state.title)
                }
                .class("public-image")
            }

            AppPublicTextBlock(text: state.content)

            if !state.authors.isEmpty {
                Section {
                    H2("Authors")
                    Div {
                        for author in state.authors {
                            A {
                                H3(author.name)
                                if !author.excerpt.isEmpty {
                                    P(author.excerpt)
                                }
                            }
                            .href(author.href)
                            .class("public-card")
                        }
                    }
                    .class("public-grid")
                }
                .class("public-section")
            }

            if !state.tags.isEmpty {
                Section {
                    H2("Tags")
                    Div {
                        for tag in state.tags {
                            A {
                                H3(tag.title)
                                if !tag.excerpt.isEmpty {
                                    P(tag.excerpt)
                                }
                            }
                            .href(tag.href)
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
}
