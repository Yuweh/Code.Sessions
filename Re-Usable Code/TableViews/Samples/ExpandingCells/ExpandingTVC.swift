

class SupportViewController: EntryModuleViewController{
    
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet weak var FAQs_list: UITableView!
    
    private var scrollViewContainer = UIView()
    
    
    var FAQuestionsData: [FAQquestion?]?
    
    override func viewDidLoad() {
        self.view.backgroundColor = .white
        
        FAQs_list.delegate = self
        FAQs_list.dataSource = self
        FAQs_list.tableFooterView = UIView()
        
        FAQuestionsData = getData()
        FAQs_list.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Support"
    }
    
    
    
    //calls data from FAQQuestionData.swift
    private func getData() -> [FAQquestion?] {
        var data: [FAQquestion?] = []
        
        let firstAnswer = [FAQanswer(answer: "One account only")]
        let firstQuestion = FAQquestion(question: "How many accounts I could register?", answer: firstAnswer)
       
        let secondAnswer = [FAQanswer(answer: "As many as possible")]
        let secondQuestion = FAQquestion(question: "How many cards I could register in 1 accoun?", answer: secondAnswer)
        
        let thirdAnswer = [FAQanswer(answer: "YESS!!")]
        let thirdQuestion = FAQquestion(question: "Could I pay or transfer with this app?", answer: thirdAnswer)
        
        return [firstQuestion, secondQuestion, thirdQuestion]
    }
    
    /*  Get parent cell for selected ExpansionCell  */
    private func getParentCellIndex(expansionIndex: Int) -> Int {
        
        var selectedCell: FAQquestion?
        var selectedCellIndex = expansionIndex
        
        while(selectedCell == nil && selectedCellIndex >= 0) {
            selectedCellIndex -= 1
            selectedCell = FAQuestionsData?[selectedCellIndex]
        }
        
        return selectedCellIndex
    }
    
    //For the expanding the cell
    private func expandCell(tableView: UITableView, index: Int) {
        // Expand Cell (add ExpansionCells
        if let answers = FAQuestionsData?[index]?.customerAnswer {
            for i in 1...answers.count {
                FAQuestionsData?.insert(nil, at: index + i)
                FAQs_list.insertRows(at: [NSIndexPath(row: index + i, section: 0) as IndexPath] , with: .top)
            }
        }
    }
    
    private func contractCell(tableView: UITableView, index: Int) {
        if let answers = FAQuestionsData?[index]?.customerAnswer {
            for i in 1...answers.count {
                FAQuestionsData?.remove(at: index+1)
                FAQs_list.deleteRows(at: [NSIndexPath(row: index+1, section: 0) as IndexPath], with: .top)
                
            }
        }
    }
    
}

extension SupportViewController: UITableViewDelegate{
}

extension SupportViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let data = FAQuestionsData {
            return data.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Row is DefaultCell
        if let rowData = FAQuestionsData?[indexPath.row] {
            let defaultCell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath) as! FAQDefaultCell
            //defaultCell.textLabel?.text = rowData.customerQuestion
            defaultCell.QuestionLabel?.text = rowData.customerQuestion
            return defaultCell
        }
            // Row is ExpansionCell
        else {
            if let rowData = FAQuestionsData?[getParentCellIndex(expansionIndex: indexPath.row)] {
                //  Create an ExpansionCell
                let expansionCell = tableView.dequeueReusableCell(withIdentifier: "ExpansionCell", for: indexPath) as! FAQExpansionCell
                
                //  Get the index of the parent Cell (containing the data)
                let parentCellIndex = getParentCellIndex(expansionIndex: indexPath.row)
                
                //  Get the index of the answer data (e.g. if there are multiple ExpansionCells
                let answerIndex = indexPath.row - parentCellIndex - 1
                
                expansionCell.AnswerLabel?.text = rowData.customerAnswer?[answerIndex].customerAnswer
                
                //  Set the cell's data
                //expansionCell.textLabel?.text = rowData.customerAnswer?[answerIndex].customerAnswer
                expansionCell.selectionStyle = .none
                return expansionCell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let data = FAQuestionsData?[indexPath.row] {
            
            // If user clicked last cell, do not try to access cell+1 (out of range)
            if(indexPath.row + 1 >= (FAQuestionsData?.count)!) {
                expandCell(tableView: tableView, index: indexPath.row)
            }
            else {
                // If next cell is not nil, then cell is not expanded
                if(FAQuestionsData?[indexPath.row+1] != nil) {
                    expandCell(tableView: tableView, index: indexPath.row)
                    // Close Cell (remove ExpansionCells)
                } else {
                    contractCell(tableView: tableView, index: indexPath.row)
                }
            }
        }
    }
    
        
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let rowData = FAQuestionsData?[indexPath.row] {
            return 40
        } else {
            return 200
        }
    }

}
