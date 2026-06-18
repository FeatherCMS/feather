import Testing

@testable import WebApp

@Suite
struct MarkdownContentRendererTestSuite {

    @Test
    func rendersMarkdownToHTML() {
        let renderer = MarkdownContentRenderer()

        let output = renderer.render(
            markdown: "# Hello\n\nThis is **markdown**.",
            requestPath: "/posts/hello/"
        )

        #expect(output.contains("<h1>Hello</h1>"))
        #expect(output.contains("<p>This is <strong>markdown</strong>.</p>"))
    }
}
