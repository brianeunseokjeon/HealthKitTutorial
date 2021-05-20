//
//  ViewController.swift
//  HealthKitTutorial
//
//  Created by brian on 2021/05/17.
//

import UIKit

class ViewController: UIViewController ,URLSessionDelegate{
    let healthManager = HealthManager.shared
    @IBOutlet weak var healthTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        healthDataInit()
    }
    
    private func healthDataInit() {
        //하루 전 데이터부터..
        let inputDate = Date().addingTimeInterval(-24*3600)
        let st = DateFormatter().customType(.toDate).string(from: inputDate)
        healthManager.healthKitAuth { [weak self] (success, error) in
            self?.healthManager.stepData(dateString: st, completion: {
                self?.healthTableView.reloadData()
            })
        }
    }
}



extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return healthManager.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HealthTableViewCell
        let data = healthManager.dataArray[indexPath.row]
        cell.configure(data.startTime, data.stepCount)
        return cell
    }
    
}
