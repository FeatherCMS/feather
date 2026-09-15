import FeatherAdmin

struct AdminViewDesignSystemDefaultInteractor: AdminViewDesignSystemInteractor {

    func getDesignSystem() async throws -> AdminViewDesignSystemModel {
        .init(
            title: "Feather CMS :: Design System",
            description: "Design-system component showcase"
        )
    }
}
