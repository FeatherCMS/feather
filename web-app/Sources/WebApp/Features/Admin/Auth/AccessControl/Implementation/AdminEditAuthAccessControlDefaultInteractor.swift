import Foundation
import Hummingbird

struct AdminEditAuthAccessControlDefaultInteractor:
    AdminEditAuthAccessControlInteractor
{
    let repository: any AdminEditAuthAccessControlRepository

    func loadState(
        isEdited: Bool,
        canEdit: Bool,
        selectedOverride: Set<String>?,
        error: String?
    ) async throws -> AdminEditAuthAccessControlState {
        let roles = try await repository.fetchRoles()
        let permissions =
            try await repository.fetchPermissions()
            .sorted {
                $0.name.localizedCaseInsensitiveCompare($1.name)
                    == .orderedAscending
            }

        var effectiveError = error
        let selectedPairs: Set<String>
        if let selectedOverride {
            selectedPairs = selectedOverride
        }
        else {
            do {
                selectedPairs = Set(
                    try await repository.fetchExistingPairs()
                        .map(\.encoded)
                )
            }
            catch let loadError {
                selectedPairs = []
                if effectiveError == nil {
                    effectiveError = loadError.displayMessage
                }
            }
        }

        return .init(
            isEdited: isEdited,
            error: effectiveError,
            canEdit: canEdit,
            roles: roles,
            permissions: permissions,
            selectedPairs: selectedPairs
        )
    }

    func save(
        input: AdminEditAuthAccessControlFormInput
    ) async throws -> AdminEditAuthAccessControlSaveResult {
        let search =
            input.search?
            .trimmingCharacters(
                in: .whitespacesAndNewlines
            ) ?? ""
        let permissions = try await repository.fetchPermissions()
        let visiblePermissionIds = Set(
            permissions
                .filter {
                    search.isEmpty
                        || $0.name.localizedCaseInsensitiveContains(search)
                }
                .map(\.id)
        )

        let desiredVisible = Set(
            input.selectedPairs.compactMap(
                AdminEditAuthAccessControlPair.init(encoded:)
            )
        )
        let existing = try await repository.fetchExistingPairs()
        let existingVisible = existing.filter {
            visiblePermissionIds.contains($0.permissionId)
        }
        let toRemove = existingVisible.subtracting(desiredVisible)
        let toAdd = desiredVisible.subtracting(existingVisible)

        for pair in toRemove {
            try await repository.delete(pair: pair)
        }

        for pair in toAdd {
            try await repository.create(pair: pair)
        }

        let persisted = try await repository.fetchExistingPairs()
        let persistedVisible = persisted.filter {
            visiblePermissionIds.contains($0.permissionId)
        }
        if persistedVisible != desiredVisible {
            let state = try await loadState(
                isEdited: false,
                canEdit: true,
                selectedOverride: input.selectedPairs,
                error:
                    "Save was not fully persisted. Please refresh and try again."
            )
            return .render(state)
        }

        return .edited
    }
}
