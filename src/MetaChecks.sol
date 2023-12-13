// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Orders {
    uint256 public totalOrders;

    struct Order {
        OrderStatus _status;
        string title;
        address creator;
    }

    mapping(uint id => Order) public allOrders;
    mapping(uint id => bool) public orderExist;

    enum OrderStatus {
        Pending,
        Shipped,
        Delivered,
        Cancelled
    }

    function createOrder(string memory _title) public {
        totalOrders++;
        Order storage newOrder = allOrders[totalOrders];
        orderExist[totalOrders] = true;
        newOrder.title = _title;
        newOrder.creator = msg.sender;
    }

    function cancelOrder(uint id) public {
        require(
            allOrders[id]._status < OrderStatus.Shipped,
            "Order Shipped Already"
        );

        if (orderExist[id] == false) {
            revert("Invalid Order");
        }
        allOrders[id]._status = OrderStatus.Cancelled;
    }

    function shipOrder(uint id) public {
        assert(msg.sender == allOrders[id].creator);
        assert(orderExist[id]);
        allOrders[id]._status = OrderStatus.Shipped;
    }
}
