import RedirectApplication
import RedirectModule

actor RuleMockQueries:
    RedirectModule.Rule.Detail.Query.Interface,
    RedirectModule.Rule.List.Query.Interface,
    RedirectModule.Rule.Search.Query.Interface,
    RedirectModule.Rule.Resolve.Query.Interface
{
    private(set) var detailCallCount = 0
    private(set) var listCallCount = 0
    private(set) var searchCallCount = 0
    private(set) var resolveCallCount = 0
    private(set) var lastID: String?
    private(set) var lastSource: String?
    private(set) var lastSearchQuery: RedirectModule.Rule.Search.Input.Query?

    let detailResult: RedirectModule.Rule.Detail.Output
    let listResult: RedirectModule.Rule.List.Output
    let searchResult: RedirectModule.Rule.Search.Output
    let resolveResult: RedirectModule.Rule.Resolve.Output?

    init(
        detailResult: RedirectModule.Rule.Detail.Output,
        listResult: RedirectModule.Rule.List.Output,
        searchResult: RedirectModule.Rule.Search.Output,
        resolveResult: RedirectModule.Rule.Resolve.Output? = nil
    ) {
        self.detailResult = detailResult
        self.listResult = listResult
        self.searchResult = searchResult
        self.resolveResult = resolveResult
    }

    func detail(id: String) async throws -> RedirectModule.Rule.Detail.Output {
        detailCallCount += 1
        lastID = id
        return detailResult
    }

    func list() async throws -> RedirectModule.Rule.List.Output {
        listCallCount += 1
        return listResult
    }

    func search(
        query: RedirectModule.Rule.Search.Input.Query
    ) async throws -> RedirectModule.Rule.Search.Output {
        searchCallCount += 1
        lastSearchQuery = query
        return searchResult
    }

    func resolve(source: String) async throws -> RedirectModule.Rule.Resolve.Output? {
        resolveCallCount += 1
        lastSource = source
        return resolveResult
    }
}
