//
//  RealmElement.swift
//  Data saving
//
//  Created by Кунгурцев Эдуард Сергеевич on 10.10.2022.
//

import Foundation
import RealmSwift

class ElementRealm: Object {
	
	@Persisted var element: String
	
}
