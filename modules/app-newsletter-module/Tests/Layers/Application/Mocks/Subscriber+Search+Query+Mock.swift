import NewsletterModule

@testable import NewsletterApplication

extension Subscriber.Search.Query {
    actor Mock: Interface {
        let result: Subscriber.Search.Output
        private(set) var lastQuery: Subscriber.Search.Input.Query?
        private(set) var searchCallCount = 0

        init(result: Subscriber.Search.Output) {
            self.result = result
        }

        func search(query: Subscriber.Search.Input.Query) async throws
            -> Subscriber.Search.Output
        {
            searchCallCount += 1
            lastQuery = query
            return result
        }
    }
}
