
protocol AdminViewDesignSystemInteractor: Sendable {

    func getDesignSystem() async throws -> AdminViewDesignSystemModel
}
