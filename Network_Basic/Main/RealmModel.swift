import Foundation

import RealmSwift

class UserMovie: Object {
    @Persisted var rank: String
    @Persisted var rankON: String
    @Persisted var movieTitle: String
    @Persisted var openDt: String
    @Persisted var dateID: String
    
    @Persisted(primaryKey: true) var objectID: ObjectId
    
    convenience init(rank: String, rankON: String, movieTitle: String, openDt: String, dateID: String) {
        self.init()
        self.rank = rank
        self.rankON = rankON
        self.movieTitle = movieTitle
        self.openDt = openDt
        self.dateID = dateID
    }
    

}
