protocol ContentRenderer: Sendable {

    func render(
        markdown: String,
        requestPath: String
    ) -> String
}
