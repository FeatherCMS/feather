import FeatherAdmin

struct AdminEditAccountProfileDefaultInteractor:
    AdminEditAccountProfileInteractor
{
    let repository: any AdminEditAccountProfileRepository

    func loadProfile(
        userID: String
    ) async throws -> AdminEditAccountProfileModel {
        try await repository.load(userID: userID)
    }

    func saveProfile(
        userID: String,
        input: AdminEditAccountProfileFormInput
    ) async throws {
        try await repository.save(userID: userID, input: input)
    }
}
