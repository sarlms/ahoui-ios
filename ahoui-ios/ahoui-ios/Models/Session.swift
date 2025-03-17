import Foundation

// Modèle de données pour une session
// Ce modèle représente une session obtenue depuis l'API.
// Il est conforme au protocole `Codable` pour permettre l'encodage/décodage JSON.
struct Session: Codable, Identifiable {
    let id: String      // Identifiant unique de la session (récupéré depuis `_id` en MongoDB)
    let name: String    // Nom de la session
    let location: String // Lieu où se déroule la session
    let startDate: Date // Date et heure de début de la session
    let endDate: Date   // Date et heure de fin de la session

    // Mapping des clés JSON vers les propriétés Swift
    // MongoDB utilise `_id` pour l'identifiant, donc on doit le mapper sur `id`
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case location
        case startDate
        case endDate
    }
}
