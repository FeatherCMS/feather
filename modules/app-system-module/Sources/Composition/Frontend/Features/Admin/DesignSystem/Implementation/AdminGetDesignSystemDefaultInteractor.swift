import FeatherAdmin

struct AdminGetDesignSystemDefaultInteractor: AdminGetDesignSystemInteractor {

    func getDesignSystem() async throws -> AdminGetDesignSystemModel {
        .init(
            title: "Feather CMS :: Design System",
            description: "Design-system component showcase"
        )
    }
}
