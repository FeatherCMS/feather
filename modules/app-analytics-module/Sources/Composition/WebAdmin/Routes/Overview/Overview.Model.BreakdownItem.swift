import AnalyticsModule

extension Overview.Model {
    struct BreakdownItem: Sendable {
        let label: String
        let count: Int
        let share: Double
    }
}
