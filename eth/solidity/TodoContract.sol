// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract Todo {
    enum Status {
        PENDING,
        COMPLETE
    }

    struct Task {
        string title;
        string description;
        Status status;
    }

    mapping(address => Task[]) private todos;

    function addTodo(
        string memory _title,
        string memory _description
    ) external {
        todos[msg.sender].push(
            Task({
                title: _title,
                description: _description,
                status: Status.PENDING
            })
        );
    }

    function getAllTodosByUser() external view returns (Task[] memory) {
        return todos[msg.sender];
    }

    function getTodo(uint256 _index) external view returns (Task memory) {
        require(_index < todos[msg.sender].length, "Invalid index");

        return todos[msg.sender][_index];
    }

    function completeTask(uint256 _index) external {
        require(_index < todos[msg.sender].length, "Invalid index");
        todos[msg.sender][_index].status = Status.COMPLETE;
    }
}
