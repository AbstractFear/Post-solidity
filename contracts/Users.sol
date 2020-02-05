pragma experimental ABIEncoderV2;

import ".././node_modules/openzeppelin/contracts/access/roles/MainAdminRole.sol";
import ".././node_modules/openzeppelin/contracts/access/roles/AdminRole.sol";
import ".././node_modules/openzeppelin/contracts/access/roles/MailWorkerRole.sol";
import ".././node_modules/openzeppelin/contracts/ownership/Ownable.sol";
// import "./MailService.sol";

/**
    @dev Создание контракта UsersContract. Контракт UsersContract хранит
    структуру пользователей, которые регистрируются в блокчейн-системе.
    Структура содержит в себе личные данные о пользователе, домашний адрес
    и роль, котораябыла ему выдана. По умолчанию равна "Пользователь".
    Является константой.
 */
contract UsersContract is MainAdminRole, AdminRole, MailWorkerRole, Ownable {

    struct usersInfo{
        address account;
        bytes32 password;
        string name;
        string secondName;
        string patronym;
        string homeAddr;
        string role;
    }

    string constant roleOf = 'Пользователь';
    /**
        @dev Маппинг балансов. Хранит в себе данные о денежных стредствах контрактах.
     */
    mapping(address => uint) internal balancesAll;
    /**
        @dev Маппинг идентификатора отделения. Хранит в себе номер
        отделения, в котором работает сотрудник.
     */
    mapping(address => string) public numberOfMailWorker;
    /**
        @dev Маппинг с пользователями. Ключевое значение uint является индексом пользователя
     */
    mapping(uint => usersInfo) public users;
    /**
        @dev Маппинг пользователей для выборки пользователя по адресу кошелька
     */
    mapping(address => usersInfo) public usersByAddress;
    /**
        @dev Маппинг пользователей для выборки пользователя по роли, назначенной ему
     */
    mapping(string => usersInfo) public usersByRole;
    /** 
        @dev Количество пользователей в структуре
    */
    uint public usersCount;

    /**
        @dev Ивент о регистрации нового пользователя. 
     */
    event NewUser(address account, string name, string secondName, string patronym, string homeAddr, string role);

    /**
        @dev Конструктор. При вызове метода deploy он заносит в базу данных главного админа
        со значениями, указанными ниже. 
     */
    constructor () public {
        address _owner = msg.sender;
        string memory _role = "Главный администратор";
        usersCount++;
        usersInfo(_owner, sha256(abi.encode('admin')), 'admin', 'admin', 'admin', 'Санкт-Петербург, ул. Мира, д. 6', _role);
        users[usersCount] = usersInfo(_owner, '', 'admin', 'admin', 'admin', 'Санкт-Петербург, ул. Мира, д. 6', _role);
        usersByAddress[_owner] = usersInfo(_owner, '', 'admin', 'admin', 'admin', 'Санкт-Петербург, ул. Мира, д. 6', _role);
        usersByRole[_role] = usersInfo(_owner, '', 'admin', 'admin', 'admin', 'Санкт-Петербург, ул. Мира, д. 6', _role);
    }

    /**
        @dev Предварительная функция регистрации аккаунта. При регистрации нового кошелька пользователь заносится в структуру, чтобы 
        потом взаимодействовать с сайтом. Также присваивает зарегистрированным пользователям роль 
        "Пользователь"
        @return bool 
    */
    function _register(address _account, string memory _password, string memory _name, string memory _secondName, string memory _patronym, string memory _homeAddr, string memory _role) private returns (bool success){
        usersCount++;
        balancesAll[_account] = _account.balance;
        users[usersCount] = usersInfo(_account, sha256(abi.encodePacked(_password)), _name, _secondName, _patronym, _homeAddr, _role);
        usersByAddress[_account] = usersInfo(_account, sha256(abi.encodePacked(_password)), _name, _secondName, _patronym, _homeAddr, _role);
        usersByRole[_role] = usersInfo(_account, sha256(abi.encodePacked(_password)), _name, _secondName, _patronym, _homeAddr, _role);
        emit NewUser(_account, _name, _secondName, _patronym, _homeAddr, roleOf);
        return true;
    }

    /**
        @dev Функция регистрации аккаунта. Вызывает предварительную функцию, которая заносит в структуру данные пользователя
        @return bool
     */

    function registration(address _account, string memory _password, string memory name, string memory secondName, string memory patronym, string memory _homeAddr) public returns (bool success){
        usersInfo[] memory usersInf = new usersInfo[](usersCount);
        address account;
        for(uint i = 0; i < usersCount; i++){
            usersInfo storage usersL = users[usersCount];
            usersInf[i] = usersL;
            account = usersL.account;
        }
        require(_account != account, 'Пользователь с таким кошельком уже существует.');
        _register(_account, _password, name, secondName, patronym, _homeAddr, roleOf);
        return true;
    }

    /**
        @dev Функция валидации аккаунта. Для авторизации зарегистрированного пользователя. 
        @return bool
     */

    function validation(address _account, string memory _password) public view returns (bool success) {
        usersInfo storage usersInf = usersByAddress[_account];
        require(keccak256(abi.encodePacked(_account)) == keccak256(abi.encode(usersInf.account)) && sha256(abi.encode(_password)) == sha256(abi.encode(usersInf.account)), 'Проверьте правильность введённых данных.');
        return true;
    }

    /**
        @dev Функция выборки пользователей по индексу. Выбирает по значению в маппинге пользователя
        и выводит его на страницу
        @return struct[1]
     */

    function getOneUser(uint index) public view returns (usersInfo memory){
        return users[index];
    }

    /**
        @dev Функция вывода всех пользователей из структуры.
        @return struct[i]
     */

    function getUsers() public view returns (usersInfo[] memory) {
        usersInfo[] memory usersInf = new usersInfo[](usersCount);
        for(uint i = 0; i < usersCount; i++){
            usersInfo storage usersL = users[usersCount];
            usersInf[i] = usersL;
        }
        return usersInf;
    }

    /**
        @dev Функция вывода пользователей по ролям. Выводит пользователя в зависимости от роли, которая была ему назначена
        @return struct[i]
     */
    function getUsersByRole(string memory _role) public view returns (usersInfo[] memory){
        usersInfo[] memory usersInf = new usersInfo[](usersCount);
        for(uint i = 0; i < usersCount; i++){
            usersInfo storage usersL = usersByRole[_role];
            usersInf[i] = usersL;
            require(keccak256(abi.encode(_role)) == keccak256(abi.encode(usersL.role)), 'Пользователя с такой ролью не существует.');
            return usersInf;
        }
    }

    /**
        @dev Функция вывода пользователя по адресу кошелька
        @return struct[1]
     */
    function getUserByAddress(address _account) public view returns (usersInfo memory){
        usersInfo storage user = usersByAddress[_account];
        return user;
    }

    /**
        @dev Функция для смены фамилии пользователя. Позволяет определённому пользователю сменить своё имя.
        Выборка пользователя происходит по адресу кошелька
        @return none
     */
    function changeSecondName(address _account, string memory _secondName) public {
        usersInfo storage user = usersByAddress[_account];
        user.secondName = _secondName;
    }

    /**
        @dev Функция для смены адреса проживания. Позволяет определённому пользователю сменить свой
        домашний адрес. Выборка по адресу кошелька
        @return none
     */
    function changeHomeAddress(address _account, string memory _homeAddr) public {
        usersInfo storage user = usersByAddress[_account];
        user.homeAddr = _homeAddr;
    }

    /**

     */
    function addNewAdmin(address _account) public onlyMainAdmin {
        addNewAdmin(_account);
        usersByAddress[_account].role = 'Админ';
    }

    function deleteAdmin(address _account) public onlyMainAdmin returns (bool success) {
        renounceAdmin(_account);
        usersByAddress[_account].role = roleOf;
        return true;
    }

    function addNewMailWorker(address _account, string memory _index) public onlyAdmin returns (bool success){
        addNewMailWorker(_account);
        usersByAddress[_account].role = 'Сотрудник почтового отделения';
        numberOfMailWorker[_account] = string(abi.encodePacked('MR', _index));
        return true;
    }

    function deleteMailWorker(address _account) public onlyAdmin returns (bool success) {
        renounceMailWorker(_account);
        usersByAddress[_account].role = roleOf;
        numberOfMailWorker[_account] = '';
        return true;
    }
    
}
