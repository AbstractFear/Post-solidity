pragma experimental ABIEncoderV2;

import "./DateTime.sol";
import "./Integers.sol";
import "./String.sol";


contract Post is DateTime {
    
    using Integers for uint;
    using String for string;

  struct post{
    string trackNumber;
    address sender;
    address reciever;
    string typeOfPost;
    uint classOfSend;
    uint dateForSending;
    uint price; // стоимость доставки
    uint weigth;
    uint declaredPrice; // объявленная ценность
    uint amount; // итоговая стоимость
    string addressTo;
    string addressFrom;
  }
  
  post[] public Posts;
  
  string[] private types = ['Письмо', 'Бандероль', 'Посылка'];
  uint[] private classes = [1, 2, 3];
  uint[] private indexes = [101000, 141980, 141981, 141982, 141983, 141800, 141801, 141802, 141803, 143400, 143401, 143402, 143403, 140100, 140101, 140102, 140103];
  uint[][] private m = [[1, 0, 10, 20, 30], 
                        [10, 1, 100, 101, 102],
                        [100, 2, 10, 0, 0],
                        [101, 2, 10, 0, 0],
                        [102, 2, 10, 0, 0],
                        [20, 1, 200, 201, 202],
                        [200, 2, 20, 0, 0],
                        [201, 2, 20, 0, 0],
                        [202, 2, 20, 0, 0]];

  string[] private posts = ['Москва', 'Дубна (главное почтовое отделение)', 'Дубна (Почтамт №1)', 'Дубна (Почтамт №2)', 'Дубна (Почтамт №3)', 'Дмитров (главное почтовое отделение)', 'Дмитров (Почтамт №1)', 'Дмитров (Почтамт №2)', 'Дмитров (Почтамт №3)', 'Красногорск (главное почтовое отделение)', 'Красногорск (Почтамт №1)', 'Красногорск (Почтамт №2)', 'Красногорск (Почтамт №3)', 'Раменское (главное почтовое отделение)', 'Раменское (Почтамт №1)', 'Раменское (Почтамт №2)', 'Раменское (Почтамт №3)'];
  uint[] private priceOfClass = [1000 finney, 700 finney , 300 finney];
  uint[] private dateOfSend = [21 seconds, 49 seconds, 77 seconds];
  
  mapping(uint => string) public indexToPost;
  mapping(uint => uint) public priceOfClassSending;
  mapping(uint => uint) public dateOfClassSending;
  
  constructor () public{
      for(uint i = 0; i < indexes.length; i++){
        indexToPost[indexes[i]] = posts[i]; 
      }
      for(uint i = 0; i < 3; i++){
        priceOfClassSending[classes[i]] = priceOfClass[i];
        dateOfClassSending[classes[i]] = dateOfSend[i];
      }
  }
  
  function goPost(uint _weight, uint _classOfSend, uint _declaredPrice, address _receiver, string memory _typeOfPost, uint _indexFrom, uint _indexTo) public returns (bool){
      require(_weight <= 10, 'Ваш вес превышает 10 килограмм.');
      if(_classOfSend.toString().compareTo('')){
          _classOfSend = 3;
      }
      if(_declaredPrice.toString().compareTo('')){
          _declaredPrice = 0;
      }
      string memory _trackNumber;
      string memory dateAll = date();
      uint _amount = priceOfClassSending[_classOfSend] * _weight + _declaredPrice * 130 finney;
      uint _price = _amount;
      _trackNumber = _trackNumber.concat('MR').concat(dateAll).concat('0').concat(_indexFrom.toString()).concat(_indexTo.toString());
      Posts.push(post(_trackNumber, msg.sender, _receiver, _typeOfPost, _classOfSend, now + 7 seconds, _price, _weight, _declaredPrice, _amount, indexToPost[_indexTo], indexToPost[_indexFrom]));
      return true;
  }
  
  function date() public view returns (string memory){
    uint year = getYear(now);
    uint month = getMonth(now);
    uint day = getDay(now);
    string memory Year = year.toString();
    string memory Month = month.toString();
    string memory Day = day.toString();
    string memory Zero;
    string memory ZeroTwo;
    
    if(Month.length() < 2){
        Zero = Zero.concat('0').concat(Month);
    } else {
        Zero = Month;
    }
    
    if(Day.length() < 2){
        ZeroTwo = ZeroTwo.concat('0').concat(Day);
    } else {
        ZeroTwo = Day;
    }
    
    string memory dateUTC = ZeroTwo.concat(Zero).concat(Year);
    return dateUTC;
  }
}