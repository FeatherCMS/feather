import AnalyticsModule

extension Log.List.Interactor {
    struct Default: Interface {
        let repository: any Log.List.Repository.Interface

        func listLogs(
            page: Int,
            search: String?,
            source: String?,
            method: String?,
            responseCode: Int?,
            from: Double?,
            to: Double?
        ) async throws -> Log.List.Model {
            try await repository.listLogs(
                page: page,
                search: search,
                source: source,
                method: method,
                responseCode: responseCode,
                from: from,
                to: to
            )
        }
    }
}
