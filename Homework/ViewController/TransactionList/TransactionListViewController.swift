
import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources
import MBProgressHUD

protocol TransactionListViewDelegate: AnyObject {
    func reloadApi()
}

class TransactionListViewController: UIViewController {
    
/// UI init
    private let tableView: UITableView = {
        let tableview = UITableView()
        tableview.rowHeight = 130
        tableview.register(TransationCell.self, forCellReuseIdentifier: TransationCell.identifier)
        return tableview
    }()
    
    private lazy var totalLabel: UILabel = {
        return UILabel()
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.setTitle("新增", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(presentAddPage(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var hud: MBProgressHUD = {
        let loading = MBProgressHUD.showAdded(to: self.view, animated: true)
        loading.mode = .indeterminate
        loading.label.text = "Loading...."
        return loading
    }()
// ============================================================
    
    private var disposeBag = DisposeBag()
    
    private lazy var transactionViewModel = {
        TransactionViewModel(TransactionRespository(ApiService()),
                      disposeBag)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        bindViewModel()

    }
    
    private func bindViewModel() {
        transactionViewModel.data.map { data in
            return "總花費： \(data.total)"
        }.bind(to: totalLabel.rx.text).disposed(by: disposeBag)
        
        transactionViewModel.readUserData().subscribe(onNext: { [weak self] status in
            switch status {
                
            case .loadstart:
                self?.hud.show(animated: true)
            case .loadEnd:
                self?.hud.hide(animated: true)
            case .error(errorMessage: let errorMessage):
                self?.hud.hide(animated: true)
                print(errorMessage)

            }
        }, onError: { error in
            self.hud.hide(animated: true)
            print(error)
        }).disposed(by: disposeBag)

        
        let dataSource = RxTableViewSectionedReloadDataSource<TrxDTO>(
            configureCell: { (_, tableview, indexPath, element) in
                guard let cell = tableview.dequeueReusableCell(withIdentifier: TransationCell.identifier, for: indexPath) as? TransationCell else {
                    return UITableViewCell()
                }
                cell.setValue(data: element)
                return cell
            },
            titleForHeaderInSection: { dataSource, sectionIndex in
                if dataSource[sectionIndex].details.count == 0 {
                    return nil
                }
                
                return dataSource[sectionIndex].time +
                       dataSource[sectionIndex].title +
                       dataSource[sectionIndex].description
            }
        )

        transactionViewModel.data.map { data in
            return data.trxDto
        }.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
    }

    private func initView() {
        view.backgroundColor = .white
        
        view.addSubview(totalLabel)
        view.addSubview(tableView)
        view.addSubview(addButton)
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        totalLabel.snp.makeConstraints { make in
            make.top.equalTo(view).offset(64)
            make.left.equalTo(view).offset(20)
        }
        
        addButton.snp.makeConstraints { make in
            make.top.equalTo(view).offset(64)
            make.right.equalTo(view).offset(-20)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view).offset(104)
            make.left.equalTo(view).offset(0)
            make.right.equalTo(view).offset(0)
            make.bottom.equalTo(view).offset(0)
        }
    }
    
    @objc func presentAddPage(_ sender: UIButton) {
        let vc = InsertTransactionViewController(self)
        self.present(vc, animated: true, completion: nil)
    }
}

extension TransactionListViewController: TransactionListViewDelegate {
    func reloadApi() {
        _ = transactionViewModel.readUserData()
    }
}

extension TransactionListViewController: UITableViewDelegate {}
