import FeatherAdmin

protocol AdminEditAccountProfileInteractor: Sendable {

    func loadProfile(
        userID: String
    ) async throws -> AdminEditAccountProfileModel

    func saveProfile(
        userID: String,
        input: AdminEditAccountProfileFormInput
    ) async throws
}
