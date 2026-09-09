import FeatherAdmin

protocol AdminGetDesignSystemInteractor: Sendable {

    func getDesignSystem() async throws -> AdminGetDesignSystemModel
}
