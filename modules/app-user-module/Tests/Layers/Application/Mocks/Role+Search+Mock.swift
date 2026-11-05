import UserModule

@testable import UserApplication

actor MockRoleSearch: Role.Search.Query.Interface {
    private(set) var searchCallCount = 0
    private let result: Role.Search.Output

    init(result: Role.Search.Output) {
        self.result = result
    }

    func search(query: Role.Search.Input.Query) async throws
        -> Role.Search.Output
    {
        searchCallCount += 1
        return result
    }
}
