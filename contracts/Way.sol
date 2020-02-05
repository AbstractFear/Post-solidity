pragma experimental ABIEncoderV2;

contract Way{
    
    struct way{
        uint[5] his;
    }
    
    // mapping(uint => way) allWays;
    
    // uint waysCount;
    
    uint[] private indexes = [101000, 141980, 141981, 141982, 141983, 141800, 141801, 141802, 141803, 143400, 143401, 143402, 143403, 140100, 140101, 140102, 140103];
    uint[][] private m = [[101000, 0, 141980, 141800, 143400, 140100], 
                        [141980, 1, 141981, 141982, 141983, 0],
                        [141981, 2, 141980, 0, 0, 0],
                        [141982, 2, 141980, 0, 0, 0],
                        [141983, 2, 141980, 0, 0, 0],
                        [141800, 1, 141801, 141802, 141803, 0],
                        [141801, 2, 141800, 0, 0, 0],
                        [141802, 2, 141800, 0, 0, 0],
                        [141803, 2, 141800, 0, 0, 0],
                        [143400, 1, 143401, 143402, 143403, 0],
                        [143401, 2, 143400, 0, 0, 0],
                        [143402, 2, 143400, 0, 0, 0],
                        [143403, 2, 143400, 0, 0, 0],
                        [140100, 1, 140101, 140102, 140103, 0],
                        [140101, 2, 140100, 0, 0, 0],
                        [140102, 2, 140100, 0, 0, 0],
                        [140103, 2, 140100, 0, 0, 0]];
                        
    uint[] a;
    uint[] b;
    // uint[] way;
    
    // function newWay(uint _a, uint _b) public returns (uint[] memory){
    //     uint[] memory his = new uint[](m.length);
    //     for(uint i = 0; i < m.length; i++){
    //         for(uint j = 0; j < m[i].length; j++){
    //             if(m[i][j] == _b && j == 0 && m[i][1] == 2){
    //                 way(m[i][2]);
    //             }
    //             if(m[i][j] == _a && j == 0 && m[i][1] == 1){
    //                 way.push(m[0][0]);
    //             } else {
    //                 if(m[i][j] == _a && j==0 && m[i][1] == 2){
    //                     a.push(m[i][2]);
    //                     way.push(m[i][2]);
    //                     way.push(m[0][0]);
    //                 }
    //             }
    //         }
    //     }
    // }
    
    function seeWay() public view returns (uint){
        return m.length;
    }
}