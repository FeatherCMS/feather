struct AdminGetSystemJobDefaultInteractor: AdminGetSystemJobInteractor {
    let repository: any AdminGetSystemJobRepository

    func execute(entity: AdminGetSystemJobModel) async throws
        -> SystemJobDetailsModel {
        try await repository.get(id: entity.id)
    }
}
