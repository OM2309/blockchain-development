// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Movies {

    struct Movie {
        string name;
        uint256 year;
    }

    
    mapping(address => Movie[]) public favoriteMovies;

    function addMovie(string memory _name, uint256 _year) public {
        favoriteMovies[msg.sender].push(Movie(_name, _year));
    }

    function getMovie(uint index)
        public
        view
        returns(string memory, uint256)
    {
        Movie memory movie = favoriteMovies[msg.sender][index];
        return (movie.name, movie.year);
    }
}


// {
//   "0x111": [
//     {
//       "name": "Anurag",
//       "age": 22
//     },
//     {
//       "name": "Rahul",
//       "age": 25
//     }
//   ],
//   "0x222": [
//     {
//       "name": "John",
//       "age": 30
//     }
//   ]
// }