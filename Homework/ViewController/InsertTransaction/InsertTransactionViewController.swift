
import UIKit
import RxSwift
import SnapKit
import RxCocoa
import MBProgressHUD

class InsertTransactionViewController: UIViewController {
    
    private weak var delegate: TransactionListViewDelegate?
    private let disposedBag = DisposeBag()
    private lazy var inserTransationViewModel = {
        InserTransatioViewModel(InserTransationRepository(ApiService()),
                                disposedBag)
    }()
    
    private lazy var inserButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .yellow
        button.setTitle("儲存", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        return button
    }()
    private lazy var detailAddButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .yellow
        button.setTitle("再加一筆", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        return button
    }()
    
    private lazy var hud: MBProgressHUD = {
        let loading = MBProgressHUD.showAdded(to: self.view, animated: true)
        loading.mode = .indeterminate
        loading.label.text = "Loading...."
        return loading
    }()
    
    private lazy var dateLable: UILabel = {
        let label = UILabel()
        label.text = "日期："
        return label
    }()
    private lazy var titleLable: UILabel = {
        let label = UILabel()
        label.text = "名稱："
        return label
    }()
    private lazy var infoLable: UILabel = {
        let label = UILabel()
        label.text = "內容："
        return label
    }()
    private lazy var dateTexfeild: UITextField = {
        let textfeild = UITextField()
        textfeild.delegate = self
        textfeild.placeholder = "yyyy/MM/dd"
        textfeild.borderStyle = UITextField.BorderStyle.roundedRect
        return textfeild
    }()
    private lazy var titleTexfeild: UITextField = {
        let textfeild = UITextField()
        textfeild.delegate = self
        textfeild.placeholder = "名稱"
        textfeild.borderStyle = UITextField.BorderStyle.roundedRect
        return textfeild
    }()
    private lazy var infoTexfeild: UITextField = {
        let textfeild = UITextField()
        textfeild.delegate = self
        textfeild.placeholder = "內容"
        textfeild.borderStyle = UITextField.BorderStyle.roundedRect
        return textfeild
    }()
    private lazy var detailName: UILabel = {
        let label = UILabel()
        label.text = "名稱："
        return label
    }()
    private lazy var detailquantityName: UILabel = {
        let label = UILabel()
        label.text = "數量："
        return label
    }()
    private lazy var detailpriceName: UILabel = {
        let label = UILabel()
        label.text = "價格："
        return label
    }()
    private lazy var detailNameTexfeild: UITextField = {
        let textfeild = UITextField()
        textfeild.delegate = self
        textfeild.placeholder = "名稱"
        textfeild.borderStyle = UITextField.BorderStyle.roundedRect
        
        return textfeild
    }()
    private lazy var detailQuantityTexfeild: UITextField = {
        let textfeild = UITextField()
        textfeild.delegate = self
        textfeild.placeholder = "數量"
        textfeild.borderStyle = UITextField.BorderStyle.roundedRect
        textfeild.keyboardType = .numberPad
        return textfeild
    }()
    private lazy var detailPriceTexfeild: UITextField = {
        let textfeild = UITextField()
        textfeild.delegate = self
        textfeild.placeholder = "價格"
        textfeild.borderStyle = UITextField.BorderStyle.roundedRect
        textfeild.keyboardType = .numberPad
        return textfeild
    }()
    private lazy var detailHeaderView: UIView = {
        let view = UIView()
        let label = UILabel()
        label.text = "詳細資料"
        view.backgroundColor = .red
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(20)
            make.center.equalTo(view)
        }
        return view
    }()
    private let detailTableView: UITableView = {
        let tableview = UITableView()
        tableview.rowHeight = 120
        tableview.register(DetailInfoCell.self, forCellReuseIdentifier: DetailInfoCell.identifier)
        return tableview
    }()
    
    private var labelArray: [UIView] = []
    private var textFeildArray: [UITextField] = []
    
    init(_ delegate: TransactionListViewDelegate) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    deinit {
        print("deinit")
    }
    
    private func initView() {
        view.backgroundColor = .white
        
        setUIarray()
        addView()
        
        labelLayoutSet(self.labelArray)
        textFieldLayoutSet(self.textFeildArray)
        buttonLayoutSet()
        anotherUILayouSet()
        
        buttonBindSet()
        tableviewBindSet()
        
    }
    
    private func addView() {
        view.addSubview(inserButton)
        view.addSubview(detailAddButton)
        view.addSubview(detailHeaderView)
        view.addSubview(detailTableView)
        for label in labelArray {
            view.addSubview(label)
        }
        
        for textfield in textFeildArray {
            view.addSubview(textfield)
        }
    }
    
    private func tableviewBindSet() {
        
        detailTableView.rx.setDelegate(self).disposed(by: disposedBag)
        
        inserTransationViewModel.detailParametersSubject.bind(to: detailTableView.rx.items(cellIdentifier: DetailInfoCell.identifier, cellType: DetailInfoCell.self)) { row, datas, cell in
            
            cell.setValue(datas: datas)
            
        }.disposed(by: disposedBag)
    }
    
    private func buttonBindSet() {
        inserButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.insertData()
        }).disposed(by: disposedBag)
        
        
        detailAddButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.detailDataAdd()
        }).disposed(by: disposedBag)
        
    }
    
    private func setUIarray() {
        labelArray = [dateLable,
                      titleLable,
                      infoLable,
                      detailName,
                      detailquantityName,
                      detailpriceName]
        
        textFeildArray = [dateTexfeild,
                          titleTexfeild,
                          infoTexfeild,
                          detailNameTexfeild,
                          detailQuantityTexfeild,
                          detailPriceTexfeild]
        
    }
    
    private func anotherUILayouSet() {
        detailHeaderView.snp.makeConstraints { make in
            make.top.equalTo(view).offset(120)
            make.height.equalTo(20)
            make.left.right.equalTo(view).offset(0)
        }
        
        detailTableView.snp.makeConstraints { make in
            make.top.equalTo(detailAddButton).offset(40)
            make.left.equalTo(view).offset(0)
            make.right.equalTo(view).offset(0)
            make.bottom.equalTo(inserButton).offset(-40)
        }
    }
    
    private func buttonLayoutSet() {
        
        inserButton.snp.makeConstraints { make in
            make.bottom.equalTo(view).offset(-20)
            make.right.equalTo(view).offset(-20)
            make.height.equalTo(40)
            make.width.equalTo(100)
        }
        
        detailAddButton.snp.makeConstraints { make in
            make.top.equalTo(detailpriceName).offset(20)
            make.right.equalTo(view).offset(-20)
            make.height.equalTo(20)
            make.width.equalTo(80)
        }
    }
    
    private func textFieldLayoutSet(_ textfeildarray: [UITextField]) {
        var topset = 20
        let lefeset = 80
        let rightset = -20
        let heightset = 20
        
        for textfield in textfeildarray {
            
            textfield.snp.makeConstraints { make in
                make.top.equalTo(view).offset(topset)
                make.left.equalTo(view).offset(lefeset)
                make.right.equalTo(view).offset(rightset)
                make.height.equalTo(heightset)
            }
            topset += 40
        }
    }
    
    private func labelLayoutSet(_ labelarray: [UIView]) {
        var topset = 20
        let lefeset = 20
        let heightset = 20
        let widthset = 60
        for label in labelArray {
            
            label.snp.makeConstraints { make in
                make.top.equalTo(view).offset(topset)
                make.left.equalTo(view).offset(lefeset)
                make.height.equalTo(heightset)
                make.width.equalTo(widthset)
            }
            
            topset += 40
        }
    }
    
    private func insertData() {
        var detailparameters: [DetailTransationParameter] = []
        let currentTime = dateToTime(date: self.dateTexfeild.text ?? "")
        do {
            detailparameters = try inserTransationViewModel.detailParametersSubject.value()
        } catch {
            
        }
        
        let parameters: InsertTransationParameter = InsertTransationParameter(currentTime,
                                                                              self.titleTexfeild.text ?? "",
                                                                              self.infoTexfeild.text ?? "",
                                                                              detailparameters)
        
        
        inserTransationViewModel.inserData(parameter: parameters).subscribe { [weak self] status in
            switch status {
                
            case .loadstart:
                self?.hud.show(animated: true)
            case .loadEnd:
                self?.hud.hide(animated: true)
                self?.showAlert(message: "儲存成功")
            case .succes:
                self?.delegate?.reloadApi()
                
            case .error(errorMessage: let errorMessage):
                self?.showAlert(message: errorMessage.description)
            }
        } onError: { [weak self] error in
            self?.showAlert(message: error.localizedDescription)
        }.disposed(by: disposedBag)
        
    }
    
    private func showAlert(message: String) {
        let controller = UIAlertController(title: "提示", message: message, preferredStyle: .alert)
        let okaction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.dismiss(animated: true, completion: nil)
        }
        controller.addAction(okaction)
        present(controller, animated: true, completion: nil)
    }
    
    private func detailDataAdd() {
        let title = self.detailNameTexfeild.text ?? ""
        let quatity = Int(self.detailQuantityTexfeild.text ?? "") ?? 0
        let price = Int(self.detailPriceTexfeild.text ?? "") ?? 0
        
        do {
            var data = try inserTransationViewModel.detailParametersSubject.value()
            data.append(DetailTransationParameter(title, quatity, price))
            inserTransationViewModel.detailParametersSubject.onNext(data)
        } catch {
            
        }
        
        self.detailNameTexfeild.text = ""
        self.detailQuantityTexfeild.text = ""
        self.detailPriceTexfeild.text = ""
    }
    
    private func dateToTime(date: String) -> Int {
        
        let formatter = DateFormatter()
        formatter.locale = Locale.init(identifier: "zh_TW")
        formatter.dateFormat = "yyyy-MM-dd"
        let dates = formatter.date(from: date)
        let time = dates!.timeIntervalSince1970
        
        return Int(time)
        
    }
}

extension InsertTransactionViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}


extension InsertTransactionViewController: UITableViewDelegate {
    
    
}
