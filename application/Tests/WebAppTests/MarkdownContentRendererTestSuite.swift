import FeatherContracts
import Testing

@testable import WebApp

@Suite
struct MarkdownContentRendererTestSuite {

    @Test
    func rendersMarkdownToHTML() async {
        let renderer = MarkdownContentRenderer(
            events: EventRegistry(),
            mediaBaseURL: ""
        )

        let output = await renderer.render(
            markdown: "# Hello\n\nThis is **markdown**.",
            requestPath: "/posts/hello/"
        )

        #expect(output.contains("<h1>Hello</h1>"))
        #expect(output.contains("<p>This is <strong>markdown</strong>.</p>"))
    }
}
