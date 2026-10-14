public enum NewAdminButtonStyle: Sendable, Equatable {
    case primary
    case secondary
    case ghost(Accent)
    case destructive
    case disabled

    public enum Accent: Sendable {
        case primary
        case secondary
    }

    var className: String {
        switch self {
        case .primary:
            "primary"
        case .secondary:
            "secondary"
        case .ghost(.primary):
            "primary-ghost"
        case .ghost(.secondary):
            "secondary-ghost"
        case .destructive:
            "destructive"
        case .disabled:
            "disabled"
        }
    }
}
