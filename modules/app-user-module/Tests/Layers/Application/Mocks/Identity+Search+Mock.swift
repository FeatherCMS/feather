import UserModule

@testable import UserApplication

actor MockIdentitySearch: Identity.Search.Query.Interface {
    private(set) var searchCallCount = 0
    private let result: Identity.Search.Output

    init(result: Identity.Search.Output) {
        self.result = result
    }

    func search(query: Identity.Search.Input.Query) async throws
        -> Identity.Search.Output
    {
        searchCallCount += 1
        return result
    }
}
