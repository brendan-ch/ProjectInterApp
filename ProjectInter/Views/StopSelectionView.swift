//
//  StopSelectionView.swift
//  ProjectInter
//
//  Created by Brendan Chen on 2025.01.06.
//

import SwiftUI

/// View which displays a list of stops for selection.
struct StopSelectionView: View {
    @State var searchText: String = ""
    @State var isEditing: Bool = false

    @Environment(GlobalStopsModel.self) var globalStopsModel: GlobalStopsModel
    @Environment(HiddenStopsModel.self) var hiddenStopsModel: HiddenStopsModel
    @Environment(GlobalSystemsModel.self) var globalSystemsModel: GlobalSystemsModel
    @Environment(LocationDataModel.self) var locationModel: LocationDataModel
    @Environment(\.dismiss) var dismiss

    private var systemId: String? {
        globalSystemsModel.selectedSystem?.id
    }

    /// Stops shown in the main "All stops" section, filtered by search and visibility.
    var searchResults: [GlobalStopsModelStop] {
        let base = isEditing ? globalStopsModel.stops : globalStopsModel.visibleStops
        if searchText.isEmpty {
            return base
        } else {
            return base.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }

    var body: some View {
        NavigationStack {
            List {
                if !isEditing {
                    Section {
                        Button {
                            automaticallySelectStop()
                            dismiss()
                        } label: {
                            HStack {
                                Image(systemName: "location.fill")

                                if locationModel.isAuthorized {
                                    Text("Automatic")
                                } else {
                                    Text("No location access")
                                }
                            }
                        }
                        .tint(Color.primary)
                        .disabled(!locationModel.isAuthorized)
                    }
                }

                Section(header: Text(isEditing ? "Stops" : "All stops")) {
                    ForEach(searchResults) { stop in
                        if isEditing {
                            editRow(for: stop)
                        } else {
                            Button {
                                globalStopsModel.selectStopId(stop.id)
                                dismiss()
                            } label: {
                                Text(stop.name)
                                    .accessibilityIdentifier("StopSelectionCollectionSearchResultItem \(stop.id)")
                            }
                            .tint(Color.primary)
                        }
                    }

                    if searchResults.isEmpty {
                        Text(isEditing ? "No stops found." : "No stops found.")
                    }
                }

                if !isEditing && searchText.isEmpty && !globalStopsModel.hiddenStops.isEmpty {
                    Section {
                        DisclosureGroup("Hidden stops (\(globalStopsModel.hiddenStops.count))") {
                            ForEach(globalStopsModel.hiddenStops) { stop in
                                HStack {
                                    Text(stop.name)
                                        .foregroundStyle(.secondary)

                                    Spacer()

                                    Button {
                                        guard let systemId else { return }
                                        hiddenStopsModel.setStopHidden(stop.id, inSystem: systemId, hidden: false)
                                    } label: {
                                        Image(systemName: "eye")
                                            .foregroundStyle(.tint)
                                    }
                                    .buttonStyle(.borderless)
                                }
                            }
                        }
                    }
                }
            }
            .searchable(
                text: $searchText,
                placement: .automatic,
                prompt: Text("Search for a stop")
            )
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        isEditing.toggle()
                    } label: {
                        Text(isEditing ? "Done" : "Edit")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Close")
                    }
                }
            }
        }
        .task {
            guard let systemId = globalSystemsModel.selectedSystem?.id else { return }

            let stopsNetworkArguments = GlobalStopsNetworkArguments(
                systemId: systemId
            )
            await globalStopsModel.refreshDataOnce(arguments: stopsNetworkArguments)
        }
    }

    /// A row in edit mode showing the stop name and a visibility toggle.
    @ViewBuilder
    private func editRow(for stop: GlobalStopsModelStop) -> some View {
        let isHidden = systemId.map { hiddenStopsModel.isStopHidden(stop.id, inSystem: $0) } ?? false

        HStack {
            Text(stop.name)
                .foregroundStyle(isHidden ? .secondary : .primary)

            Spacer()

            Button {
                guard let systemId else { return }
                hiddenStopsModel.toggleStopHidden(stop.id, inSystem: systemId)

                // If the currently selected stop was just hidden, re-run auto-select
                if hiddenStopsModel.isStopHidden(stop.id, inSystem: systemId)
                    && globalStopsModel.selectedStop?.id == stop.id {
                    automaticallySelectStop()
                }
            } label: {
                Image(systemName: isHidden ? "eye.slash" : "eye")
                    .foregroundStyle(isHidden ? .secondary : .tint)
            }
            .buttonStyle(.borderless)
            .accessibilityLabel(isHidden ? "Show stop" : "Hide stop")
        }
    }

    func automaticallySelectStop() {
        if let location = locationModel.lastUpdatedLocation {
            globalStopsModel.automaticallySelectStop(for: location)
        } else {
            globalStopsModel.automaticallySelectStop()
        }
    }
}

#Preview {
    let hiddenStopsModel = HiddenStopsModel()
    let globalStopsModel = GlobalStopsModel.buildPlaceholder()

    StopSelectionView()
        .environment(globalStopsModel)
        .environment(hiddenStopsModel)
        .environment(GlobalSystemsModel.buildPlaceholder())
        .environment(LocationDataModel())
}
