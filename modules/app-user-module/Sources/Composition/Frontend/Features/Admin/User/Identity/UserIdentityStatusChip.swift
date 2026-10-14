import FeatherAdmin

enum UserIdentityStatusChip {
    static func make(status: String) -> AdminChip {
        switch status {
        case "invited":
            AdminChip(label: "Invited", color: .blue)
        case "active":
            AdminChip(label: "Active", color: .green)
        case "suspended":
            AdminChip(label: "Suspended", color: .orange)
        case "deactivated":
            AdminChip(label: "Deactivated", color: .red)
        case "anonymized":
            AdminChip(label: "Anonymized", color: .purple)
        default:
            AdminChip(label: status, color: .blue)
        }
    }
}
