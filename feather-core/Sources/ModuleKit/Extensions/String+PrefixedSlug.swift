extension String {
    public func prefixedSlug(
        with prefix: String
    ) -> String {
        let prefixParts =
            prefix
            .split(separator: "/")
            .map(String.init)
            .map(\.slugified)
            .filter { !$0.isEmpty }

        let value = slugified
        return String(
            (prefixParts + [value]).joined(separator: "/").prefix(254)
        )
    }
}
