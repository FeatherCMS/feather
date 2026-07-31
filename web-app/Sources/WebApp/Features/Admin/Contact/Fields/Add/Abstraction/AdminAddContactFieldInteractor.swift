protocol AdminAddContactFieldInteractor: Sendable {
    func getAddContactField() async throws -> AdminAddContactFieldModel
    func postAddContactField(payload: ContactFieldFormInput)
        async throws -> AdminAddContactFieldModel
}
