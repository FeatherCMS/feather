import Domain

public protocol LogRepository: Repository {

    func insert(
        _ model: Log.New
    ) async throws -> Log
}
