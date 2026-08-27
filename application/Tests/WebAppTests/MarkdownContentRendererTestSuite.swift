import FeatherContracts
import Testing

import WebFrontend

@Suite
struct MarkdownContentRendererTestSuite {

    private struct TestBlockRenderer: WebMarkdownBlockRenderer {
        let name = "ContactForm"

        func render(
            request: WebMarkdownBlockRendererRequest
        ) async -> String? {
            guard let identifier = request.arguments["id"] else { return nil }
            return "<form data-id=\"\(identifier)\"></form>"
        }
    }

    @Test
    func rendersMarkdownToHTML() async {
        let renderer = DefaultMarkdownRenderer(
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

    @Test
    func rendersCustomBlockDirectivesThroughTheMarkdownAST() async {
        var events = EventRegistry()
        events.register(
            event: WebMarkdownBlockRendererProvider.self,
            context: WebMarkdownBlockRendererRequest.self
        ) { _, _ in
            TestBlockRenderer()
        }

        let renderer = DefaultMarkdownRenderer(
            events: events,
            mediaBaseURL: ""
        )

        let output = await renderer.render(
            markdown: "# Welcome\n\n@ContactForm(id: form-123)",
            requestPath: "/"
        )

        #expect(output.contains("<h1>Welcome</h1>"))
        #expect(output.contains("<form data-id=\"form-123\"></form>"))
    }
}
