import Foundation

enum StatsStore {
    private static let key = "playerStats"

    static func load() -> PlayerStats {
        guard let data = UserDefaults.standard.data(forKey: key),
              let stats = try? JSONDecoder().decode(PlayerStats.self, from: data)
        else { return PlayerStats() }
        return stats
    }

    static func save(_ stats: PlayerStats) {
        guard let data = try? JSONEncoder().encode(stats) else { return }
        UserDefaults.standard.set(data, forKey: key)
    }

    static func reset() {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
