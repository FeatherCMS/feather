import AnalyticsModule

extension Log.View.Interactor {
    struct Default: Interface {
        let repository: any Log.View.Repository.Interface

        func execute(id: String) async throws -> Log.View.Model {
            .init(log: try await repository.get(id: id))
        }
    }
}
