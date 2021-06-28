//
//  ViewController.swift
//  SimplePeopleList
//
//  Created by Can Dikici on 28.06.2021.
//

//
//  ViewController.swift
//  ScorpInterview
//
//  Created by Can Dikici on 26.06.2021.
//

import UIKit

class ViewController: UIViewController  {
    
    
   
    

    private let refreshControl = UIRefreshControl()
    var people = [Person]()
    
    

    @IBOutlet weak var peopleList: UITableView!
    @IBOutlet weak var emptyListMessage: UILabel!
    
    @IBOutlet weak var tryButton: UIButton!
    
    
    
    @objc func fetchPeople(){
        DataSource.fetch(next: nil) { resp, error in
            print(resp?.people.count ?? "null")
            DispatchQueue.main.async {
                if(resp != nil){
                    if let pe = resp?.people {
                        pe.forEach { p in
                            let isExist = self.people.contains(where:{$0.id == p.id});
                            if (!isExist){
                                
                                self.people.append(p)
                            }else{
                                print("existing user!")
                            }
                        }
                    }
                }else{
                    self.emptyListMessage.text = "There is an error. Please try again later."
                    self.emptyListMessage.numberOfLines = 2
                    self.emptyListMessage.adjustsFontSizeToFitWidth = true
                    
                    let alert = UIAlertController(title: "Fetch People", message: error?.errorDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok.", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    if(self.people.isEmpty){
                        self.tryButton.isHidden = false
                    }
                    
                }
               
                if (resp?.people.count ?? 0) > 0 {
                    self.peopleList.isHidden = false
                    self.tryButton.isHidden = true
                    self.emptyListMessage.isHidden = true
                    self.peopleList.reloadData()
                } else if self.people.isEmpty {
                   
                    self.tryButton.isHidden = false
                    self.peopleList.isHidden = true
                    self.emptyListMessage.isHidden = false
                }
                  
            }
        }
        if refreshControl.isRefreshing {
            refreshControl.endRefreshing()
            
        }

    }
    
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        peopleList.delegate = self
        peopleList.dataSource = self
        
        peopleList.isHidden = true
        tryButton.isHidden = true
        fetchPeople()
        tryButton.addTarget(self, action: #selector(fetchPeople), for: .touchUpInside)
        peopleList.refreshControl = refreshControl
        refreshControl.attributedTitle = NSAttributedString(string: "Fetching other people")
        refreshControl.addTarget(self, action: #selector(fetchPeople), for: .valueChanged)
        // Do any additional setup after loading the view.
    }
}

extension ViewController:UITableViewDelegate {}
extension ViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = peopleList.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let currentLastItem = people[indexPath.row]
        cell.textLabel?.text = currentLastItem.fullName + "  -  " +  String(currentLastItem.id)
        return cell
    }
}


