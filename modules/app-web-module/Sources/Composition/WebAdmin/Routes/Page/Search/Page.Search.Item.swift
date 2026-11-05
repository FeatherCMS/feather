import WebModule

extension Page.Search {
    struct Item: Sendable {
        let id: String
        let title: String
        let metadata: Metadata
        let availability: Availability
    }
}
