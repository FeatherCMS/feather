import AnalyticsModule

extension NotFound.View {
    struct Model: Sendable {
        let title: String
        let description: String
        let from: String
        let to: String
        let overview: Overview.Model
    }
}
