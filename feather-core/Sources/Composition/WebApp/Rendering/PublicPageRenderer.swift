public import HTML
public import Hummingbird
public import WebComponents

public protocol PublicPageRenderer: Sendable {
    func render<T: Component>(
        request: Request,
        title: String,
        description: String,
        imagePath: String,
        content: T
    ) -> Response where T.HTML: FlowContent
}
