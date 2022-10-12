//
//  ViewController.swift
//  Data saving
//
//  Created by Кунгурцев Эдуард Сергеевич on 10.10.2022.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {

	@IBOutlet weak var tableView: UITableView!
	
	var arrayOfElement: [ElementRealm] = [] {
		didSet {
			tableView.reloadData()
		}
	}
	
	
	 private let realm = try! Realm()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tableView.delegate = self
		tableView.dataSource = self
		
		arrayOfElement = getElement()
		// Ниже удаляем потому что сделал didSet и там ReloadData() удаляется
//		self.tableView.reloadData()
		
	}
	

	private func createAlert() {
		let dialogMessage = UIAlertController(title: "Инфо", message: "Добавте покупку", preferredStyle: .alert)

		let returnButton = UIAlertAction(title: "Return", style: .default) { action in
			// В замыкание можно написать все что хочешь
			let message = dialogMessage.textFields?.first?.text
			self.saveElement(name: message ?? "sds")
			self.arrayOfElement = self.getElement()
			// Ниже удаляем потому что сделал didSet и там ReloadData() удаляется
//			self.tableView.reloadData()
		}
		

		let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) { action in

		}
		
		self.present(dialogMessage, animated: true, completion: nil)
		dialogMessage.addAction(cancelButton)
		dialogMessage.addAction(returnButton)
		dialogMessage.addTextField { textField in
			textField.placeholder = ""
		}
		
	}
	
	private func saveElement(name: String) {
		let nameRealm = ElementRealm()
		nameRealm.element = name
		
		try? realm.write({
			realm.add(nameRealm)
		})
		
	}
	
	private func deleteElement(name: ElementRealm) {
		
		try? realm.write({
			realm.delete(name)

		})}
		
	
	@IBAction func addElementPressed() {
		createAlert()
	}
	
	// Функция возвращает все объекты из базы данных
	private func  getElement() -> [ElementRealm] {
		let result = realm.objects(ElementRealm.self)
		return Array(result)
	}
	
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		arrayOfElement.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = UITableViewCell()
		cell.textLabel?.text = arrayOfElement[indexPath.row].element
		return cell
	}
	
	//   Обработка свайпа
	
	func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

		let delete = UIContextualAction(style: .normal, title: "Delete") { [weak self] _, _, completion in
			guard let self = self else {return}
			self.deleteElement(name: self.arrayOfElement[indexPath.row])
			self.arrayOfElement.remove(at: indexPath.row)
			completion(true)
			
		}

		delete.backgroundColor = .red

		return UISwipeActionsConfiguration(actions: [delete])
	}
	
}

