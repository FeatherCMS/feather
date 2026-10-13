import FeatherContracts
import Foundation
import Testing

import WebFrontend

@Suite
struct MarkdownContentRendererTestSuite {

    private struct TestBlockRenderer: WebMarkdownBlockRenderer {
        let name = "ContactForm"

        func render(
            request: WebMarkdownBlockRendererRequest
        ) async -> String? {
            guard let identifier = request.arguments["key"] else { return nil }
            return "<form data-id=\"\(identifier)\"></form>"
        }
    }

    @Test
    func rendersMarkdownToHTML() async {
        let renderer = DefaultMarkdownRenderer(
            events: EventRegistry(),
            mediaResolver: MediaResolver(
                mediaBaseURL: URL(string: "http://localhost:8080")!
            )
        )

        let output = await renderer.render(
            markdown: "# Hello\n\nThis is **markdown**."
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
            mediaResolver: MediaResolver(
                mediaBaseURL: URL(string: "http://localhost:8080")!
            )
        )

        let output = await renderer.render(
            markdown: "# Welcome\n\n@ContactForm(key: form-123)"
        )

        #expect(output.contains("<h1>Welcome</h1>"))
        #expect(output.contains("<form data-id=\"form-123\"></form>"))
    }

    @Test
    func rendersVideoBlockDirectives() async {
        var events = EventRegistry()
        WebMarkdownEventHandlers.register(in: &events)

        let renderer = DefaultMarkdownRenderer(
            events: events,
            mediaResolver: MediaResolver(
                mediaBaseURL: URL(string: "http://localhost:8080")!
            )
        )

        let output = await renderer.render(
            markdown: "@Video(source: \"https://www.youtube.com/embed/example\", kind: \"embed\")\n\n@Video(source: \"https://www.youtube.com/embed/second\", kind: \"embed\")"
        )

        #expect(output.contains("src=\"https://www.youtube.com/embed/example\""))
        #expect(output.contains("src=\"https://www.youtube.com/embed/second\""))
        #expect(output.contains("<iframe"))
    }
}
