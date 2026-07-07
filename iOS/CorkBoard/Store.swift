import Foundation
import Combine

@MainActor
final class CorkBoardStore: ObservableObject {
    @Published private(set) var entries: [BottleEntry] = []

    /// Free-tier cap. Deliberately set above the seed-data count so a fresh
    /// install never trips the paywall immediately.
    static let freeLimit = 15

    private let fileName = "corkboard_entries.json"

    private var fileURL: URL {
        let dir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        if !FileManager.default.fileExists(atPath: dir.path) {
            try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        }
        return dir.appendingPathComponent(fileName)
    }

    init() {
        load()
    }

    var canAddMore: Bool {
        entries.count < Self.freeLimit
    }

    @discardableResult
    func add(_ entry: BottleEntry) -> Bool {
        guard canAddMore else { return false }
        entries.append(entry)
        save()
        return true
    }

    func update(_ entry: BottleEntry) {
        guard let idx = entries.firstIndex(where: { $0.id == entry.id }) else { return }
        entries[idx] = entry
        save()
    }

    func delete(at offsets: IndexSet) {
        entries.remove(atOffsets: offsets)
        save()
    }

    func delete(_ entry: BottleEntry) {
        entries.removeAll { $0.id == entry.id }
        save()
    }

    func toggleFavorite(_ entry: BottleEntry) {
        guard let idx = entries.firstIndex(where: { $0.id == entry.id }) else { return }
        entries[idx].isFavorite.toggle()
        save()
    }

    private func load() {
        if let data = try? Data(contentsOf: fileURL),
           let decoded = try? JSONDecoder().decode([BottleEntry].self, from: data) {
            entries = decoded
        } else {
            entries = Self.seedData()
            save()
        }
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(entries) else { return }
        try? data.write(to: fileURL, options: .atomic)
    }

    static func seedData() -> [BottleEntry] {
        [
            BottleEntry(name: "Barolo Riserva", detail: "2018 - Piedmont", date: Calendar.current.date(byAdding: .day, value: 365, to: Date()) ?? Date()),
            BottleEntry(name: "Malbec Reserva", detail: "2021 - Mendoza", date: Calendar.current.date(byAdding: .day, value: 120, to: Date()) ?? Date()),
            BottleEntry(name: "Chablis 1er Cru", detail: "2022 - Burgundy", date: Calendar.current.date(byAdding: .day, value: 30, to: Date()) ?? Date())
        ]
    }
}
